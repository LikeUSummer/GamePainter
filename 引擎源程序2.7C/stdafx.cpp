/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "stdafx.h"

/////////////////////////////////////全局变量定义////////////////////////////////////////
int g_Width; //客户区宽度
int g_Height;//客户区高度
CDC g_BufDC; //缓冲DC
CBitmap g_BufBMP;//缓冲位图
CPen g_Pen;
CBrush g_Brush;
COLORREF g_LineColor=RGB(0,0,0);//全局线条颜色
COLORREF g_BrushColor=RGB(255,255,123);//全局画刷颜色
CFont g_Font;   
UINT g_DT;//时钟周期

CxImage** g_ImageLib;
int g_nImage=0;
int g_MaxImage=32; //最大图片库容量
CGamePainterView* g_pView;
CMainFrame* g_pWnd;

CLuaBox g_Box; //lua脚本管理对象
//CInternetSession g_Session;//网络会话对象