// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#include <cmath>
#include <fstream>
#include <functional>
#include <iostream>
#include <map>
#include <memory>
#include <sstream>
#include <vector>

#include "win.h"
#include "lua_machine.h"
#include "codec.h"

#include <gdiplus.h>

std::shared_ptr<Window> g_window;
LuaMachine g_luaMachine;
ULONG_PTR g_GDIPlusToken {0};
std::map<uint32_t, std::unique_ptr<Gdiplus::Image>> g_imageMap;
std::unique_ptr<Gdiplus::Font> g_font;
std::unique_ptr<Gdiplus::Pen> g_pen;
HCURSOR g_cursor;
constexpr int GAME_LOOP_TIMER_ID {960103};
constexpr int GAME_LOOP_TIMER_PERIOD {100}; // ms

struct Initialiser {
    Initialiser()
    {
        // 初始化 GDI+
        Gdiplus::GdiplusStartupInput startupInput;
        Gdiplus::GdiplusStartup(&g_GDIPlusToken, &startupInput, NULL);

        g_pen = std::make_unique<Gdiplus::Pen>(Gdiplus::Color::Black, 1.5f);
        Gdiplus::FontFamily fontFamily(_T("宋体"));
        g_font = std::make_unique<Gdiplus::Font>(&fontFamily, 11.f);
    }
};
Initialiser g_initialiser;

// 图像接口
int AddImage(lua_State* L)
{
    std::string imageFileName = luaL_checkstring(L, 1);

    uint32_t id = g_imageMap.size();
    while (g_imageMap.count(id)) {
        ++id;
    }
    g_imageMap[id] = std::make_unique<Gdiplus::Image>(UTF8ToWide(imageFileName).c_str());
    lua_pushnumber(L, id);
    return 1;
}

int RemoveImage(lua_State* L)
{
    int id = lua_tointeger(L, 1);
    g_imageMap.erase(id);
    return 0;
}

int GetImageSize(lua_State* L)
{
    int id = lua_tointeger(L, 1);
    lua_pushinteger(L, g_imageMap[id]->GetWidth());
    lua_pushinteger(L, g_imageMap[id]->GetHeight());
    return 2;
}

int DrawImage(lua_State* L)
{
    int id = lua_tointeger(L, 1);
    int dx = lua_tointeger(L, 2);
    int dy = lua_tointeger(L, 3);
    // int dw = lua_tointeger(L, 4);
    // int dh = lua_tointeger(L, 5);
    int sx = lua_tointeger(L, 5);
    int sy = lua_tointeger(L, 6);
    int sw = lua_tointeger(L, 7);
    int sh = lua_tointeger(L, 8);

    int width = g_imageMap[id]->GetWidth();
    int height = g_imageMap[id]->GetHeight();
    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    Gdiplus::Rect rect(dx, dy, width, height);
    graphics.DrawImage(g_imageMap[id].get(), rect,
        sx, sy, sw, sh, Gdiplus::Unit::UnitPixel);
    return 0;
}

int DrawImageByScale(lua_State* L)
{
    int id = lua_tointeger(L, 1);
    int x = lua_tointeger(L, 2);
    int y = lua_tointeger(L, 3);
    double sx = lua_tonumber(L, 4);
    double sy = lua_tonumber(L, 5);
    int width = g_imageMap[id]->GetWidth();
    int height = g_imageMap[id]->GetHeight();

    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    graphics.DrawImage(g_imageMap[id].get(), x, y, width * sx, height * sy);
    return 0;
}

int DrawImageByFrame(lua_State* L)
{
    int id = lua_tointeger(L, 1);
    int x = lua_tointeger(L, 2);
    int y = lua_tointeger(L, 3);
    int dx = lua_tointeger(L, 4);  // 裁剪起点
    int dw = lua_tointeger(L, 5);  // 裁剪宽度
    int height = g_imageMap[id]->GetHeight();

    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    Gdiplus::Rect rect(x, y, dw, height);
    graphics.DrawImage(g_imageMap[id].get(), rect,
        dx, 0, dw, height, Gdiplus::Unit::UnitPixel);
    return 0;
}

// 图形接口
int DrawPoint(lua_State* L)
{
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);

    uint32_t color = lua_tointeger(L, 3);
    SetPixel(g_window->GetBufferDC(), x, y, color);
    return 0;
}

int DrawLine(lua_State* L)
{
    int x1 = lua_tointeger(L, 1);
    int y1 = lua_tointeger(L, 2);
    int x2 = lua_tointeger(L, 3);
    int y2 = lua_tointeger(L, 4);

    COLORREF ARGB = lua_tointeger(L, 5);
    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    graphics.DrawLine(g_pen.get(), x1, y1, x2, y2);
    return 0;
}

int DrawRect(lua_State* L)
{
    int x1 = lua_tointeger(L, 1);
    int y1 = lua_tointeger(L, 2);
    int x2 = lua_tointeger(L, 3);
    int y2 = lua_tointeger(L, 4);

    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    graphics.DrawRectangle(g_pen.get(), x1, y1, x2, y2);
    return 0;
}

int DrawSolidRect(lua_State* L)
{
    int x1 = lua_tointeger(L, 1);
    int y1 = lua_tointeger(L, 2);
    int x2 = lua_tointeger(L, 3);
    int y2 = lua_tointeger(L, 4);
    COLORREF ARGB = lua_tointeger(L, 5);

    Gdiplus::Color color(ARGB);
    Gdiplus::SolidBrush brush(color);
    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    graphics.FillRectangle(&brush, x1, y1, x2, y2);
    return 0;
}

int DrawString(lua_State* L)
{
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);
    std::wstring text = UTF8ToWide(luaL_checkstring(L, 3));
    COLORREF ARGB = lua_tointeger(L, 4);

    Gdiplus::Color color(ARGB);
    Gdiplus::SolidBrush brush(color);
    Gdiplus::Graphics graphics(g_window->GetBufferDC());
    graphics.SetTextRenderingHint(Gdiplus::TextRenderingHint::TextRenderingHintClearTypeGridFit);
    graphics.SetSmoothingMode(Gdiplus::SmoothingMode::SmoothingModeAntiAlias);
    Gdiplus::PointF position(x, y);
    graphics.DrawString(text.c_str(), text.length(), g_font.get(), position, &brush);
    return 0;
}

// 多媒体
int AddMedia(lua_State* L)
{
    MCI_OPEN_PARMS mciOpen {0};
    std::wstring mediaName = UTF8ToWide(lua_tostring(L, 1));
    mciOpen.lpstrElementName = mediaName.c_str();
    mciOpen.lpstrDeviceType = _T("waveaudio");
	MCIERROR mciErr;
	mciErr = mciSendCommand(0, MCI_OPEN,
        MCI_OPEN_TYPE_ID | MCI_OPEN_ELEMENT,
        (DWORD_PTR)&mciOpen);
    if (mciErr) {
        std::wstringstream wss;
        wss << mciErr;
        lua_pushinteger(L, -1);
    } else {
        lua_pushinteger(L, mciOpen.wDeviceID);
    }
    return 1;
}

int RemoveMedia(lua_State* L)
{
    MCIDEVICEID id = lua_tointeger(L, 1);
    MCI_GENERIC_PARMS mciParams;
    MCIERROR mciErr = mciSendCommand(id, MCI_CLOSE, 0, (DWORD_PTR)&mciParams);
    return 0;
}

int PlayMedia(lua_State* L)
{
    MCIDEVICEID id = lua_tointeger(L, 1);
    MCI_PLAY_PARMS mciPlay {0};
    MCIERROR mciErr = mciSendCommand(id, MCI_PLAY, 0, (DWORD_PTR)&mciPlay);
    return 0;
}

int PauseMedia(lua_State* L)
{
    MCIDEVICEID id = lua_tointeger(L, 1);
    MCI_PLAY_PARMS mciPlay {0};
    MCIERROR mciErr = mciSendCommand(id, MCI_PAUSE, 0, (DWORD_PTR)&mciPlay);
    return 0;
}

int ResumeMedia(lua_State* L)
{
    MCIDEVICEID id = lua_tointeger(L, 1);
    MCI_PLAY_PARMS mciPlay {0};
    MCIERROR mciErr = mciSendCommand(id, MCI_RESUME, 0, (DWORD_PTR)&mciPlay);
    return 0;
}

int StopMedia(lua_State* L)
{
    MCIDEVICEID id = lua_tointeger(L, 1);
    MCI_PLAY_PARMS mciPlay {0};
    MCIERROR mciErr = mciSendCommand(id, MCI_STOP, 0, (DWORD_PTR)&mciPlay);
    return 0;
}

// 设置接口
int SetPen(lua_State* L)
{
    COLORREF ARGB = lua_tointeger(L, 1);
    int width = lua_tointeger(L, 2);

    g_pen->SetColor(Gdiplus::Color(ARGB));
    g_pen->SetWidth(width);
    return 0;
}

int SetFont(lua_State* L)
{
    std::string fontName = luaL_checkstring(L, 1);
    float fontSize = lua_tonumber(L, 2);

    Gdiplus::FontFamily fontFamily(UTF8ToWide(fontName).c_str());
    g_font = std::make_unique<Gdiplus::Font>(&fontFamily, fontSize);
    return 0;
}

int SetCursor(lua_State* L)
{
    std::wstring cursorFileName = UTF8ToWide(luaL_checkstring(L, 1));
    g_cursor = (HCURSOR)LoadImage(NULL, cursorFileName.c_str(), IMAGE_CURSOR,
        0, 0, LR_LOADFROMFILE);
    SetCursor(g_cursor);
    return 0;
}

int SetIMEPosition(lua_State* L)
{
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);
    HIMC himc = ImmGetContext(g_window->handle_);
    COMPOSITIONFORM cpf;
    cpf.dwStyle = CFS_FORCE_POSITION;
    cpf.ptCurrentPos.x = x;
    cpf.ptCurrentPos.y = y;
    ImmSetCompositionWindow(himc, &cpf);
    return 0;
}

int SetClock(lua_State* L)
{
    int dt = lua_tointeger(L, 1);
    KillTimer(g_window->handle_, GAME_LOOP_TIMER_ID);
    SetTimer(g_window->handle_, GAME_LOOP_TIMER_ID, dt, NULL);
    return 0;
}

int SetWindowName(lua_State* L)
{
    std::wstring title = UTF8ToWide(luaL_checkstring(L, 1));
    g_window->SetTitle(title);
    return 0;
}

int SetCanvas(lua_State* L)
{
    int width = lua_tointeger(L, 1);
    int height = lua_tointeger(L, 2);

    int cx = GetSystemMetrics(SM_CXFRAME) + width;
    int cy = GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYFRAME) + height;
    g_window->SetPosition(0, 0, cx, cy);
    return 0;
}

int UpdateCanvas(lua_State* L) {
    g_window->ExchangeBuffer();
    return 0;
}

int Exit(lua_State* L)
{
    PostQuitMessage(0);
    return 0;
}

const luaL_Reg g_gameLib[] = {
    {"AddImage", AddImage},
    {"RemoveImage", RemoveImage},
    {"GetImageSize", GetImageSize},
    {"DrawImage", DrawImage},
    {"DrawImageByFrame", DrawImageByFrame},
    {"DrawImageByScale", DrawImageByScale},

    {"DrawPoint", DrawPoint},
    {"DrawLine", DrawLine},
    {"DrawRect", DrawRect},
    {"DrawSolidRect", DrawSolidRect},
    {"DrawString", DrawString},

    {"SetPen", SetPen},
    {"SetFont", SetFont},
    {"SetCursor", SetCursor},
    {"SetIMEPosition", SetIMEPosition},
    {"SetWindowName", SetWindowName},
    {"SetClock", SetClock},
    {"SetCanvas", SetCanvas},

    {"AddMedia", AddMedia},
    {"RemoveMedia", RemoveMedia},
    {"PlayMedia", PlayMedia},
    {"PauseMedia", PauseMedia},
    {"ResumeMedia", ResumeMedia},
    {"StopMedia", StopMedia},

    {"UpdateCanvas", UpdateCanvas},
    {"Exit", Exit},
    {NULL, NULL}
};

void OnCreate(HWND handle, WPARAM wParam, LPARAM lParam)
{
    SetTimer(handle, GAME_LOOP_TIMER_ID, GAME_LOOP_TIMER_PERIOD, NULL);
    // 初始化 Lua 脚本
    std::string scriptPath;
    LuaMachine machine;
    if (!machine.LoadScriptFromFile("config/config.lua")) {
        MessageBox(NULL, _T("加载配置文件出错"), _T("提示"), MB_OK);
        exit(1);
    }
    machine.Get("scriptPath", scriptPath);

    g_luaMachine.RegisterLibrary("Painter", g_gameLib);
    // g_luaMachine.RegisterLibrary("utf8", g_lutf8lib);
    scriptPath += "/Game.lua";
    if (!g_luaMachine.LoadScriptFromFile(scriptPath)) {
        MessageBox(NULL, UTF8ToWide(g_luaMachine.errorInfo_).c_str(), _T("提示"), MB_OK);
        exit(1);
    }
    g_luaMachine.Call("GameInit");
}

// 消息处理
void OnPaint(HWND handle, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT ps;
    HDC hdc = BeginPaint(handle, &ps);
    g_window->ExchangeBuffer();
    EndPaint(handle, &ps);
}

// 消息传递
void OnSize(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnSize", 0,
        (int)LOWORD(lParam), (int)HIWORD(lParam));
}

void OnTimer(HWND handle, WPARAM wParam, LPARAM lParam)
{
    if (wParam == GAME_LOOP_TIMER_ID) {
        g_luaMachine.Call("GameLoop");
    }
}

void OnLButtonDown(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnLButtonDown", 0, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
}

void OnRButtonDown(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnRButtonDown", 0, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
}

void OnLButtonUp(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnLButtonUp", 0, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
}

void OnLButtonClick(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnLButtonClick", 0, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
}

void OnMouseMove(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnMouseMove", 0, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
}

void OnMouseWheel(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnMouseWheel", 0, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam),
        GET_WHEEL_DELTA_WPARAM(wParam));
}

void OnKeyDown(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnVKeyDown", 0, (int)wParam, (int)LOWORD(lParam));
}

void OnChar(HWND handle, WPARAM wParam, LPARAM lParam)
{
    g_luaMachine.Call("OnCKeyDown", 0, (int)wParam, (int)LOWORD(lParam));
}

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPreInst, LPSTR lpCmd, int nShowMode)
{
    Window::Initialise(hInst);
    g_window = std::make_shared<Window>();

    g_window->handlerMap_[WM_CREATE] = OnCreate;
    g_window->handlerMap_[WM_PAINT] = OnPaint;
    g_window->handlerMap_[WM_DESTROY] = [](HWND handle, WPARAM wParam, LPARAM lParam) {
        PostQuitMessage(0);
    };
    g_window->handlerMap_[WM_QUIT] = [](HWND handle, WPARAM wParam, LPARAM lParam) {
        Gdiplus::GdiplusShutdown(g_GDIPlusToken);
        KillTimer(handle, GAME_LOOP_TIMER_ID);
    };

    g_window->handlerMap_[WM_LBUTTONDOWN] = OnLButtonDown;
    g_window->handlerMap_[WM_LBUTTONUP] = OnLButtonUp;
    g_window->handlerMap_[WM_RBUTTONDOWN] = OnRButtonDown;
    g_window->handlerMap_[WM_LBUTTONDBLCLK] = OnLButtonClick;
    g_window->handlerMap_[WM_MOUSEMOVE] = OnMouseMove;
    g_window->handlerMap_[WM_MOUSEWHEEL] = OnMouseWheel;
    g_window->handlerMap_[WM_KEYDOWN] = OnKeyDown;
    g_window->handlerMap_[WM_CHAR] = OnChar;
    g_window->handlerMap_[WM_SIZE] = OnSize;
    g_window->handlerMap_[WM_TIMER] = OnTimer;

    g_window->SetTitle(_T("GamePainter | 东方盛夏"));
    g_window->Create(); // 在 handlerMap_ 初始化后调用 Create，避免部分消息未得到处理
    g_window->Show();

    MSG message;
    while (GetMessage(&message, NULL, 0, 0)) {
        TranslateMessage(&message);
        DispatchMessage(&message);
    }
    return message.wParam;
}
