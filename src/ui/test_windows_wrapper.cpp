#include "win.h"

#include <cmath>
#include <functional>
#include <memory>
#include <sstream>

void OnPaint(HWND handle, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT ps;
    HDC hdc = BeginPaint(handle, &ps);
    HBRUSH brush = CreateSolidBrush(0x22bbff);
    RECT rect {0, 0, 200, 200};
    FillRect(hdc, &rect, brush);
    EndPaint(handle, &ps);
}

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPreInst, LPSTR lpCmd, int nShowMode)
{
    Window::Initialise(hInst);
    auto window = std::make_shared<Window>();

    window->handlerMap_[WM_PAINT] = OnPaint;
    window->handlerMap_[WM_KEYDOWN] = [&window](HWND handle, WPARAM wParam, LPARAM lParam) {
        if (wParam == VK_LEFT) { // 按方向左键让窗口销毁并重建
            std::wstringstream className;
            className << "NewWindowClass" << rand();
            WNDCLASSEX winClass {0};
            winClass.cbSize = sizeof(WNDCLASSEX);
            winClass.lpfnWndProc = Window::OnMessage;
            winClass.hInstance = window->instance_;
            winClass.lpszClassName = className.str().c_str(); 
            winClass.style = CS_HREDRAW | CS_VREDRAW;
            winClass.hbrBackground =  CreateSolidBrush((COLORREF)rand());
            RegisterClassEx(&winClass);

            std::wstringstream windowName;
            windowName << _T("旧貌换新颜") << rand();
            HWND hwnd = CreateWindow(
                className.str().c_str(),
                windowName.str().c_str(),
                WS_OVERLAPPEDWINDOW,
                CW_USEDEFAULT, 0, CW_USEDEFAULT, 0,
                NULL, NULL,
                window->instance_, NULL
            );
            auto win = window->windowMap_[handle];
            RECT rect = win->GetRect();
            win->CreateFromHandle(hwnd);
            win->SetPosition(rect.left, rect.top,
                rect.right - rect.left, rect.bottom - rect.top);
        } else if (wParam == VK_RIGHT) { // 按方向右键新建窗口
            std::wstringstream windowName;
            windowName << _T("桃李满天下") << rand();
            auto win = std::make_shared<Window>();
            win->title_ = windowName.str();
            win->handlerMap_ = window->handlerMap_;
            win->Create();
            win->Show(SW_SHOWNORMAL);
        } else if (wParam == VK_ESCAPE) { // 按 ESC 键结束程序
            PostQuitMessage(0);
        }
    };
    window->handlerMap_[WM_DESTROY] = VoidHandler;

    window->Create();
    window->Show(SW_SHOWNORMAL);

    MSG message;
    while (GetMessage(&message, NULL, 0, 0)) {
        TranslateMessage(&message);
        DispatchMessage(&message);
    }
    return message.wParam;
}
