// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#include "win.h"

HINSTANCE Window::instance_ {nullptr};
std::map<HWND, std::shared_ptr<Window>> Window::windowMap_;
std::wstring Window::defaultWindowClassName_ {_T("GamePainterWindowClass")};
void VoidHandler(HWND handle, WPARAM wParam, LPARAM lParam) {}

bool Window::Initialise(HINSTANCE instance)
{
    instance_ = instance;
    WNDCLASSEX winClass {0}; // 结构体成员清零[必要]
    winClass.cbSize = sizeof(WNDCLASSEX); // 指明结构体尺寸[WNDCLASSEX 必要，WNDCLASS 不必要]
    winClass.lpfnWndProc = Window::OnMessage;
    winClass.hInstance = instance;
    winClass.lpszClassName = defaultWindowClassName_.c_str(); 
    winClass.style = CS_HREDRAW | CS_VREDRAW; // 自动重绘背景
    winClass.hbrBackground =  (HBRUSH)(COLOR_WINDOW + 1); // CreateSolidBrush((COLORREF)rand());
    // winClass.cbClsExtra = 0; // 窗口类的附加内存
    // winClass.cbWndExtra = 0; // 窗口的附加内存
    // winClass.hIcon = LoadIcon(instance_, MAKEINTRESOURCE(IDI_APPLICATION));
    // winClass.hIconSm = LoadIcon(winClass.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    // winClass.hCursor = LoadCursor(NULL, IDC_ARROW);
    // winClass.lpszMenuName = menuName_.c_str();
    if(!RegisterClassEx(&winClass)) {
        return false;
    }
    return true;
}

Window::Window()
{
    // 注册占位消息，框架需要对它们做额外的响应处理
    handlerMap_[WM_DESTROY] = VoidHandler;
}

// 使用默认的窗口类创建
bool Window::Create()
{
    if (windowMap_.count(handle_)) {
        Remove();
    }
    return CreateFromClassName(defaultWindowClassName_);
}

bool Window::CreateFromClassName(const std::wstring& className) // 若需要使用系统控件，可传入系统预设窗口类名
{
    if (windowMap_.count(handle_)) {
        Remove(); // 关闭和移除当前管理的窗口
    }
    className_ = className;
    handle_ = CreateWindow(
        className.c_str(),
        title_.c_str(),
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, 0, CW_USEDEFAULT, 0,
        NULL, NULL,
        instance_, NULL
    ); // CreateWindow 执行过程中会发送 WM_CREATE 消息并等待它处理完，这样本框架就捕获不到 WM_CREATE

    windowMap_.insert({handle_, shared_from_this()});
    // 因此我们在 windowMap_ 赋值后，重发一次 WM_CREATE 消息，此时请忽略消息参数
    SendMessage(handle_, WM_CREATE, 0 , 0);
    return true;
}

void Window::CreateFromHandle(HWND handle)
{
    if (windowMap_.count(handle_)) {
        Remove();
    }
    constexpr int BUFFER_SIZE = 256;
    std::vector<TCHAR> text(BUFFER_SIZE, 0);
    GetClassName(handle, text.data(), BUFFER_SIZE);
    className_ = text.data();
    GetWindowText(handle, text.data(), BUFFER_SIZE);
    title_ = text.data();

    handle_ = handle;
    windowMap_.insert({handle_, shared_from_this()});
}

void Window::SetTitle(const std::wstring& title)
{
    title_ = title;
    if (handle_) {
        SetWindowText(handle_, title.c_str());
    }
}

void Window::SetPosition(int x, int y, int width, int height)
{
    SetWindowPos(handle_, NULL, x, y, width, height, SWP_SHOWWINDOW);
    UpdateView();
}

void Window::UpdateView()
{
    RECT rect;
    GetClientRect(handle_, &rect);
    InvalidateRect(handle_, &rect, true);
    UpdateWindow(handle_); // 绕过消息队列，立即调用 WndProc 处理重绘消息
}

void Window::Show(int mode)
{
    ShowWindow(handle_, mode);
    UpdateWindow(handle_);
}

RECT Window::GetRect()
{
    RECT rect;
    GetWindowRect(handle_, &rect);
    return rect;
}

HDC Window::GetBufferDC()
{
    if (!bufferDC_) {
        HDC hdc = GetDC(handle_);
        bufferDC_ = CreateCompatibleDC(hdc);
        int width = GetSystemMetrics(SM_CXFULLSCREEN);
        int height = GetSystemMetrics(SM_CYFULLSCREEN);
        HBITMAP bitmap = CreateCompatibleBitmap(hdc, width, height);
        SelectObject(bufferDC_, bitmap);
        SetBkMode(bufferDC_, TRANSPARENT);
        ReleaseDC(handle_, hdc);
    }
    return bufferDC_;
}

void Window::ExchangeBuffer()
{
    HDC hdc = GetDC(handle_);
    RECT rect;
    GetClientRect(handle_, &rect);
    BitBlt(hdc, rect.left, rect.top, rect.right, rect.bottom,
        GetBufferDC(), rect.left, rect.top, SRCCOPY);
    ReleaseDC(handle_, hdc);
}

void Window::Remove()
{
    destroyPromise_ = std::make_unique<std::promise<bool>>();
    std::future<bool> destroyFuture = destroyPromise_->get_future();
    DestroyWindow(handle_);
    destroyFuture.wait(); // 等待窗口销毁回调处理完，否则可能导致用户资源泄漏
    destroyPromise_ = nullptr;
    windowMap_.erase(handle_);
}

LRESULT Window::OnMessage(HWND handle, UINT message, WPARAM wParam, LPARAM lParam)
{
    if (windowMap_.count(handle) && windowMap_[handle]->handlerMap_.count(message)) {
        windowMap_[handle]->handlerMap_[message](handle, wParam, lParam);
        if (message == WM_DESTROY && windowMap_[handle]->destroyPromise_) {
            windowMap_[handle]->destroyPromise_->set_value(true);
        }
        return 0;
    }
    return DefWindowProc(handle, message, wParam, lParam);
}