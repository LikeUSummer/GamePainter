// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
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
void VoidHandler(HWND handle, WPARAM wParam, LPARAM lParam);

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
    std::unique_ptr<std::promise<bool>> destroyPromise_;

public:
    Window();
    bool Create();
    bool CreateFromClassName(const std::wstring& className);
    void CreateFromHandle(HWND handle);
    void Remove();

    void Show(int mode = SW_SHOWNORMAL);
    RECT GetRect();
    HDC GetBufferDC();
    void ExchangeBuffer();
    void UpdateView();

    void SetTitle(const std::wstring& title);
    void SetPosition(int x, int y, int width, int height);

public:
    static LRESULT __stdcall OnMessage(HWND handle, UINT message, WPARAM wParam, LPARAM lParam);
    static bool Initialise(HINSTANCE instance);
};
#endif
