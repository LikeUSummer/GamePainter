/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "stdafx.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// 唯一的一个 CGamePainterApp 对象
CGamePainterApp theApp;

BOOL CGamePainterApp::InitInstance()
{
	// 如果一个运行在 Windows XP 上的应用程序清单指定要
	// 使用 ComCtl32.dll 版本 6 或更高版本来启用可视化方式，
	//则需要 InitCommonControlsEx()。否则，将无法创建窗口。
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// 将它设置为包括所有要在应用程序中使用的
	// 公共控件类。
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();

	// 初始化 OLE 库
	if (!AfxOleInit())
	{
		AfxMessageBox(IDP_OLE_INIT_FAILED);
		return FALSE;
	}
	AfxEnableControlContainer();
	// 标准初始化
	// 如果未使用这些功能并希望减小
	// 最终可执行文件的大小，则应移除下列
	// 不需要的特定初始化例程
	// 更改用于存储设置的注册表项
	// TODO: 应适当修改该字符串，
	// 例如修改为公司或组织名
	SetRegistryKey(_T("应用程序向导生成的本地应用程序"));
	LoadStdProfileSettings(4);  // 加载标准 INI 文件选项(包括 MRU)
	// 注册应用程序的文档模板。文档模板
	// 将用作文档、框架窗口和视图之间的连接
	CSingleDocTemplate* pDocTemplate;
	pDocTemplate = new CSingleDocTemplate(
		IDR_MAINFRAME,
		RUNTIME_CLASS(CGamePainterDoc),
		RUNTIME_CLASS(CMainFrame),       // 主 SDI 框架窗口
		RUNTIME_CLASS(CGamePainterView));
	if (!pDocTemplate)
		return FALSE;
	AddDocTemplate(pDocTemplate);

	// 分析标准外壳命令、DDE、打开文件操作的命令行
	CCommandLineInfo cmdInfo;
	ParseCommandLine(cmdInfo);

	// 调度在命令行中指定的命令。如果
	// 用 /RegServer、/Register、/Unregserver 或 /Unregister 启动应用程序，则返回 FALSE。
	if (!ProcessShellCommand(cmdInfo))
		return FALSE;

   ////////////////////////////以下是数据初始化程序//////////////////////////////
	//以下初始化部分全局变量
    //获取全局指针
	g_pWnd=(CMainFrame*)AfxGetMainWnd();
	g_pView=(CGamePainterView*)g_pWnd->GetActiveView();
	//创建绘图设备
	g_Font.CreateFont(13, 
		0, 
		0, 
		0, 
		FW_LIGHT, 
		FALSE, 
		FALSE, 
		0, 
		GB2312_CHARSET,  
		OUT_DEFAULT_PRECIS, 
		CLIP_DEFAULT_PRECIS, 
		DEFAULT_QUALITY, 
		DEFAULT_PITCH | FF_SWISS, 
		"宋体"); 
	g_Pen.CreatePen(PS_SOLID,1,g_LineColor);
	g_Brush.CreateSolidBrush(g_BrushColor);
	//初始化缓冲绘图DC
	g_BufDC.CreateCompatibleDC(g_pView->GetDC());
	g_BufBMP.CreateCompatibleBitmap(g_pView->GetDC(),g_Width,g_Height);
	g_BufDC.SelectObject(&g_BufBMP);
	g_BufDC.SelectObject(&g_Font);
	g_BufDC.SelectObject(&g_Pen);
	g_BufDC.SelectObject(&g_Brush);
	g_BufDC.SetBkMode(TRANSPARENT);
	g_BufDC.FillSolidRect(0,0,g_Width,g_Height,RGB(255,255,123));
	//启动时钟
	g_DT=100; //100ms,10帧每秒
	//启动窗口
	m_pMainWnd->ShowWindow(SW_SHOW);
	m_pMainWnd->UpdateWindow();
	//游戏程序初始化
	g_Box.callVoidFunc("GameInit");//调用脚本初始化程序
	g_pView->SetTimer(666,g_DT,NULL);
	return TRUE;
}

CGamePainterApp::CGamePainterApp()
{
	// TODO: 在此处添加构造代码，
	// 将所有重要的初始化放置在 InitInstance 中
}

BEGIN_MESSAGE_MAP(CGamePainterApp, CWinApp)

END_MESSAGE_MAP()


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();
// 对话框资源
	enum { IDD = IDD_ABOUTBOX };
protected:
	virtual void DoDataExchange(CDataExchange* pDX); 
// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()



