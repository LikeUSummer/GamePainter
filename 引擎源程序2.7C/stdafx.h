/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#pragma once

#ifndef _SECURE_ATL
#define _SECURE_ATL 1
#endif

#ifndef VC_EXTRALEAN
#define VC_EXTRALEAN            // 从 Windows 头中排除极少使用的资料
#endif

#include "targetver.h"

#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS      // 某些 CString 构造函数将是显式的

// 关闭 MFC 对某些常见但经常可放心忽略的警告消息的隐藏
#define _AFX_ALL_WARNINGS

#include <afxwin.h>         // MFC 核心组件和标准组件
#include <afxext.h>         // MFC 扩展
#include <afxdisp.h>        // MFC 自动化类

#ifndef _AFX_NO_OLE_SUPPORT
#include <afxdtctl.h>           // MFC 对 Internet Explorer 4 公共控件的支持
#endif
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>                     // MFC 对 Windows 公共控件的支持
#endif // _AFX_NO_AFXCMN_SUPPORT

#ifdef _UNICODE
#if defined _M_IX86
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='x86' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_IA64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='ia64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_X64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='amd64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#else
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")
#endif
#endif

//引入CxImage库
#include "CxImage/Include/ximage.h"
#pragma comment(lib,"CxImage/Lib/cximage.lib")
#pragma comment(lib,"CxImage/Lib/png.lib")
#pragma comment(lib,"CxImage/Lib/jasper.lib")
#pragma comment(lib,"CxImage/Lib/jbig.lib")
#pragma comment(lib,"CxImage/Lib/Jpeg.lib")
#pragma comment(lib,"CxImage/Lib/libpsd.lib")
#pragma comment(lib,"CxImage/Lib/libdcr.lib")
#pragma comment(lib,"CxImage/Lib/mng.lib")
#pragma comment(lib,"CxImage/Lib/Tiff.lib")
#pragma comment(lib,"CxImage/Lib/zlib.lib")
#include "GamePainter.h"
#include "GamePainterDoc.h"
#include "GamePainterView.h"
#include "MainFrm.h"
#include <memory.h>
#include <MMSystem.h>
#include <afxinet.h>
#include <wininet.h>
#include <comdef.h>
#pragma comment(lib,"winmm.lib")
///////////////////////////////////////////////////////全局变量/////////////////////////////////////////////////////////////////////
extern int g_Width; //客户区宽度
extern int g_Height;//客户区高度
extern CDC g_BufDC; //缓冲DC
extern CBitmap g_BufBMP;//缓冲位图
extern CFont g_Font;         //全局字体
extern CPen g_Pen;
extern CBrush g_Brush;
extern COLORREF g_LineColor;
extern COLORREF g_BrushColor;
extern UINT g_DT;//时钟周期
extern CxImage** g_ImageLib;
extern int g_nImage;     //当前图片库使用量
extern int g_MaxImage; //最大图片库容量
extern CGamePainterView* g_pView;
extern CMainFrame* g_pWnd;
extern CLuaBox g_Box;  //lua脚本管理对象
//extern CInternetSession g_Session;//网络会话对象

