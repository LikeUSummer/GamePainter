#ifndef WINDOW_H
#define WINDOW_H

#ifndef UNICODE
#define UNICODE // for windows.h
#endif
#ifndef _UNICODE
#define _UNICODE // for tchar.h
#endif

#include <tchar.h>
#include <windows.h>
#include <windowsx.h>

#include <future>
#include <functional>
#include <map>
#include <memory>
#include <mutex>
#include <set>
#include <string>
#include <sstream>

class Window;
using MSG_HANDLER = std::function<void (HWND, WPARAM, LPARAM)>;
void VoidHandler(HWND handle, WPARAM wParam, LPARAM lParam) {}

class Window : public std::enable_shared_from_this<Window> {
public:
    static HINSTANCE instance_;
    static std::wstring defaultWindowClassName_;
    static std::map<HWND, std::shared_ptr<Window>> windowMap_;

public:
    HWND handle_ {nullptr};
    std::wstring className_;
    std::wstring title_;
    std::map<UINT, MSG_HANDLER> handlerMap_;
    HDC bufferDC_ {nullptr}; // 用于双缓冲绘图
    std::shared_ptr<std::promise<bool>> destroyPromise_;

public:
    Window();
    bool Create();
    bool CreateFromClassName(const std::wstring& className);
    void CreateFromHandle(HWND handle);
    void Remove();

    void Show(int mode = SW_SHOWNORMAL);
    HDC GetBufferDC();
    void ExchangeBuffer();
    void UpdateView();

    void SetTitle(const std::wstring& title);
    void SetPosition(int x, int y, int width, int height);

public:
    static LRESULT __stdcall OnMessage(HWND handle, UINT message, WPARAM wParam, LPARAM lParam);
    static bool Initialise(HINSTANCE instance);
};
HINSTANCE Window::instance_ {nullptr};
std::map<HWND, std::shared_ptr<Window>> Window::windowMap_;
std::wstring Window::defaultWindowClassName_ {_T("GamePainterWindowClass")};

bool Window::Initialise(HINSTANCE instance)
{
    instance_ = instance;
    WNDCLASSEX winClass {0}; // 结构体成员清零（必要）
    winClass.cbSize = sizeof(WNDCLASSEX); // 指明结构体尺寸（WNDCLASSEX 必要，WNDCLASS 不必要）
    winClass.lpfnWndProc = Window::OnMessage;
    winClass.hInstance = instance;
    winClass.lpszClassName = defaultWindowClassName_.c_str(); 
    // winClass.hbrBackground =  (HBRUSH)(COLOR_WINDOW + 1); // CreateSolidBrush((COLORREF)rand());
    // winClass.style = CS_HREDRAW | CS_VREDRAW; // 自动重绘背景
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
    // 注册占位消息
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

// 若需要使用系统控件，可传入系统预设窗口类名
bool Window::CreateFromClassName(const std::wstring& className)
{
    if (windowMap_.count(handle_)) {
        Remove();
    }
    className_ = className;
    handle_ = CreateWindow(
        className.c_str(),
        title_.c_str(),
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, 0, CW_USEDEFAULT, 0,
        NULL, NULL,
        instance_, NULL
    ); // CreateWindow 执行过程中就要发送和处理完 WM_CREATE 消息，这样本框架就不能正常处理它

    windowMap_.insert({handle_, shared_from_this()});
    SendMessage(handle_, WM_CREATE, 0 , 0); // 因此我们在窗口表初始化后，重发一次 WM_CREATE 消息 
    return true;
}

void Window::CreateFromHandle(HWND handle)
{
    if (windowMap_.count(handle_)) {
        Remove();
    }
    constexpr int BUFFER_SIZE = 256;
    std::vector<TCHAR> className(BUFFER_SIZE, 0);
    GetClassName(handle, className.data(), BUFFER_SIZE);
    className_ = className.data();
    GetWindowText(handle, className.data(), BUFFER_SIZE);
    title_ = className.data();

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
    SetWindowPos(handle_, NULL, x, y, width, height, SWP_NOMOVE);
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

HDC Window::GetBufferDC()
{
    if (!bufferDC_) {
        HDC hdc = GetDC(handle_);
        bufferDC_ = CreateCompatibleDC(hdc);
        int width = GetSystemMetrics(SM_CXFULLSCREEN);
        int height = GetSystemMetrics(SM_CYFULLSCREEN);
        HBITMAP bitmap = CreateCompatibleBitmap(hdc, width, height);
        SelectObject(bufferDC_, bitmap);
        // RECT rect {0, 0, width, height};
        // FillRect(bufferDC_, &rect, CreateSolidBrush(RGB(255,200,50)));
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
    destroyPromise_ = std::make_shared<std::promise<bool>>();
    DestroyWindow(handle_);
    destroyPromise_->get_future().wait(); // 等待窗口销毁回调处理完，否则可能导致用户资源泄漏
    windowMap_.erase(handle_);
}

LRESULT Window::OnMessage(HWND handle, UINT message, WPARAM wParam, LPARAM lParam)
{
    if (windowMap_.count(handle)) {
        if (windowMap_[handle]->handlerMap_.count(message)) {
            windowMap_[handle]->handlerMap_[message](handle, wParam, lParam);
            if (message == WM_DESTROY) {
                windowMap_[handle]->destroyPromise_->set_value(true);
            }
            return 0;
        }
    }
    return DefWindowProc(handle, message, wParam, lParam);
}
#endif
