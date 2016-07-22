/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "stdafx.h"
#include "GamePainter.h"

#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CMainFrame

IMPLEMENT_DYNCREATE(CMainFrame, CFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)

	ON_WM_DESTROY()
END_MESSAGE_MAP()


// CMainFrame 构造/析构

CMainFrame::CMainFrame()
{

}

CMainFrame::~CMainFrame()
{
}


BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	if( !CFrameWnd::PreCreateWindow(cs) )
		return FALSE;

    //这里去掉了WS_THICKFRAME，WS_MAXIMIZEBOX属性
	cs.style = WS_OVERLAPPED | WS_CAPTION | FWS_ADDTOTITLE
		  | WS_MINIMIZEBOX | WS_SYSMENU;
	//cs.style&=(~WS_THICKFRAME); //禁止拉动改变窗口尺寸
	//cs.style&=(~WS_MAXIMIZEBOX);

	return TRUE;
}

//重载此函数去掉菜单栏
BOOL CMainFrame::Create(LPCTSTR lpszClassName, LPCTSTR lpszWindowName, DWORD dwStyle , const RECT& rect , CWnd* pParentWnd , LPCTSTR lpszMenuName , DWORD dwExStyle , CCreateContext* pContext)
{
	return CFrameWnd::CreateEx(dwExStyle,lpszClassName,lpszWindowName,dwStyle,
		rect.left,rect.top,rect.right-rect.left,rect.bottom-rect.top,
		pParentWnd->GetSafeHwnd(),
		NULL,              //无菜单
		(LPVOID)pContext);
}


// CMainFrame 诊断

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
	CFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
	CFrameWnd::Dump(dc);
}

#endif //_DEBUG


//程序退出时做一些清理（不做什么也可以）

void CMainFrame::OnDestroy()
{
	CFrameWnd::OnDestroy();
    g_Box.callVoidFunc("OnExit");
}
