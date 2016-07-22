/*
   程序开源，请勿用于商业开发
   怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬  最后修改：12月9日
*/

#include "stdafx.h"
#include "GamePainterView.h"
#include "MusicBox.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

///////////////全局变量/////////////////////
MusicBox g_Music;
int addImage(lua_State* L);    //(path)添加PNG图片到图片库，游戏常用PNG图片，故默认添加PNG格式
int addJPG(lua_State* L);      //(path)添加JPG图片到图片库，游戏地图一般较大且不需要透明，采用jpg格式更高效
int drawImage(lua_State* L);   //(id,x,y,left,width)在x,y处绘制图片，图片裁剪：从left处裁剪width宽度
int drawImageR(lua_State* L);  //(id,x,y,sx,sy,w,h)在x,y处绘制图片，图片裁剪：从sx,sy处裁剪一个w*h的矩形
int drawPoint(lua_State* L);   //(x,y,color)绘制一个点
int drawLine(lua_State* L);    //(x1,y1,x2,y2)绘制一条直线
int drawRect(lua_State* L);    //(x1,y1,x2,y2)绘制线框矩形
int drawSolidRect(lua_State* L); //(x1,y1,x2,y2,color)绘制实心矩形
int drawText(lua_State* L);    //(x,y,text)绘制一行文字
int drawTextR(lua_State* L);   //(text,x1,y1,x2,y2,format)在矩形区域绘制文字
int delImage(lua_State* L);    //(id)从图片库卸载编号为id的图片
int setClock(lua_State* L) ;   //(dT)设置时钟周期为dT，单位为毫秒
int setCanvas(lua_State* L);   //(width,height)设置游戏画布尺寸
int setPen(lua_State* L);      //(color,weight)设置当前画笔颜色与宽度
int setFont(lua_State* L);     //(fontName,fontSize)设置当前文字字体与尺寸
int setCursor(lua_State* L);   //(cursorPath)设置自定义鼠标指针，格式为.cur的图片
int setBrush(lua_State* L);    //(color)设置当前画刷颜色
int setTextColor(lua_State*L); //(color)设置当前文字颜色
int setImageScale(lua_State*L);//(id,scale)改变图片的物理尺寸，缩放因子是scale
int updateCanvas(lua_State* L);//更新游戏画布
int getImageW(lua_State* L);   //(id)获取图片宽度
int getImageH(lua_State* L);   //(id)获取图片高度
int addMusic(lua_State* L);    //(path)注册音乐文件到音乐库，目前支持mp3格式
int delMusic(lua_State* L);    //(id)从音乐库移除编号为id的音乐
int playMusic(lua_State* L);   //(id)播放编号为id的音乐
int stopMusic(lua_State* L);   //(id)停止播放编号为id的音乐
int pauseMusic(lua_State* L);  //(id)暂停播放编号为id的音乐
int resumeMusic(lua_State* L); //(id)继续播放编号为id的音乐
int setGameName(lua_State* L); //(name)设置游戏窗口的标题
int getNetText(lua_State* L);  //(URL)获取指定url的网络文本资源
int getNetFile(lua_State* L);  //(URL,savePath)从指定的url下载网络文件，保存到本地路径（savePath指定）
int utf8ToGB2312(lua_State* L);//(utfStr)转码函数，把UTF-8转成GB码
int unicodeToGB2312(lua_State* L);//(uniStr)转码函数，把Unicode转成GB码
int setNetOption(lua_State* L);//(连接超时，发送超时，接收超时，重试次数)用来设置网络请求时的超时等待参数
int beginThread(lua_State*L);  //(threadFuncName)lua传递一个函数作为一个新线程执行，注意这个lua函数不能带有参数
int exitGame(lua_State* L);    //退出游戏
const luaL_Reg CLib[]= {  
	{"addImage", addImage},
	{"addJPG",addJPG},
	{"drawImage",drawImage},
	{"delImage",delImage},
	{"drawSolidRect",drawSolidRect},
	{"drawRect",drawRect},
	{"drawText",drawText},
	{"drawTextR",drawTextR},
	{"drawLine",drawLine},
	{"drawPoint",drawPoint},
	{"setPen",setPen},
	{"setBrush",setBrush},
	{"updateCanvas",updateCanvas},
	{"setTextColor",setTextColor},
	{"setFont",setFont},
	{"setImageScale",setImageScale},
	{"setClock",setClock},
	{"setCanvas",setCanvas},
	{"getImageW",getImageW},
	{"getImageH",getImageH},
	{"addMusic",addMusic},
	{"delMusic",delMusic},
	{"playMusic",playMusic},
	{"stopMusic",stopMusic},
	{"pauseMusic",pauseMusic},
	{"resumeMusic",resumeMusic},
	{"drawImageR",drawImageR},
	{"setGameName",setGameName},
	{"setCursor",setCursor},
	{"getNetText",getNetText},
	{"getNetFile",getNetFile},
	{"utf8ToGB2312",utf8ToGB2312},
	{"unicodeToGB2312",unicodeToGB2312},
	{"setNetOption",setNetOption},
	{"beginThread",beginThread},
	{"exitGame",exitGame},
	{NULL, NULL}  
};  
int imageManager();
void DrawGame();
void UTF8ToGB2312(CString utfStr,CString& gbstr);
void UnicodeToGB2312(LPCWSTR uniStr,CString& gbstr);
UINT luaThread(LPVOID pParam);
CString LoadLuaFile(CString fileName);
HCURSOR g_Cur;
bool   g_setMyCur=false;
bool   g_gameStart=false;
int    g_connectTOT=5000; //连接超时
int    g_sendTOT=5000;    //发送超时
int    g_receiveTOT=5000; //接收超时
int    g_retryTime=1;  //重试次数
CString g_threadName; //lua传入的线程函数名
CWinThread* g_threadGroup[32];//线程对象组，最多容纳32个线程
lua_State*  g_stateGroup[32]; //lua状态机数组，和线程组对应
//////////////////////////////////////////////

IMPLEMENT_DYNCREATE(CGamePainterView, CView)

BEGIN_MESSAGE_MAP(CGamePainterView, CView)
	ON_WM_SIZE()
	ON_WM_TIMER()
	ON_WM_RBUTTONDOWN()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_MOUSEWHEEL()
	ON_WM_KEYDOWN()
	ON_WM_CHAR()
//	ON_WM_ERASEBKGND()
    ON_WM_MOUSEMOVE()
    ON_WM_LBUTTONUP()
	ON_WM_SETCURSOR()
END_MESSAGE_MAP()

CGamePainterView::CGamePainterView()
{
	//初始化图片库
	g_MaxImage=32;
	g_ImageLib=(CxImage**)malloc(sizeof(UINT)*g_MaxImage);//new CxImage[g_MaxImage];//
	//初始化Lua脚本
	CLuaBox tempLua;
	CString configText=LoadLuaFile("config//config.lua");
	tempLua.initText(configText);
	CString  luaPath=tempLua.getString("scriptPath");
	luaPath+="//Game.lua";
	CString Code=LoadLuaFile(luaPath);
	g_Box.regFuncLib("Painter",CLib); //注册函数库
	g_Box.initText(Code);
}

// CGamePainterView 绘制
void CGamePainterView::OnDraw(CDC* pDC)
{
	DrawGame();
}

void DrawGame() //外部函数操作客户区DC进行双缓冲绘制，使图像稳定
{
	CDC* pDC=g_pView->GetDC();
	pDC->BitBlt(0,0,g_Width,g_Height,&g_BufDC,0,0,SRCCOPY);
	//pDC->DeleteDC();  //经过测试这里使用DeleteDC也可安全释放临时DC
	g_pWnd->ReleaseDC(pDC);
}

int imageManager()
{
	if(g_nImage>g_MaxImage-2) //提前分配
	{
		CxImage** pTest=(CxImage**)realloc(g_ImageLib,(g_MaxImage+32)*sizeof(UINT)); //扩大指针数组
		if(pTest)
		{
			g_ImageLib=pTest;
			g_MaxImage+=32;
		}
		else
			return 0;   //内存不足，返回0报错
	}
	return 1;
}

int updateCanvas(lua_State* L)
{
	DrawGame();
	return 0;
}

int addImage(lua_State* L)  //lua调用此函数注册图片到全局图片库，参数为(char* imageName)
{
	CString imageName;
	imageName=lua_tostring(L,1);
	if(!imageManager())
	{
		MessageBox(NULL,"内存资源不足，请调整游戏资源布局","提示",0);
		lua_pushnumber(L,-1); //给lua返回-1报错
		return 1;
	}
	CxImage* image=new CxImage;
	image->Load(imageName,CXIMAGE_SUPPORT_PNG);
	g_ImageLib[g_nImage]=image;
	lua_pushnumber(L,g_nImage); //返回图片内部ID,即数组索引
	g_nImage++;
	return 1;
}

int addJPG(lua_State* L)
{
	CString imageName;
	imageName=lua_tostring(L,1);
	if(!imageManager())
	{
		MessageBox(NULL,"内存资源不足，请调整游戏资源布局","提示",0);
		lua_pushnumber(L,-1); //给lua返回-1报错
		return 1;
	}
	CxImage* image=new CxImage;
	image->Load(imageName,CXIMAGE_SUPPORT_JPG);
	g_ImageLib[g_nImage]=image;
	lua_pushnumber(L,g_nImage); //返回图片内部ID,即数组索引
	g_nImage++;
	return 1;
}

int drawImage(lua_State* L)//lua调用此函数在指定位置绘制库编号为id的图片，参数为(int id , int x , int y, int cx,int dx)
{
	int id=lua_tointeger(L,1);
	int x=lua_tointeger(L,2);
	int y=lua_tointeger(L,3);
	int cx=lua_tointeger(L,4);//裁剪起点
	int dx=lua_tointeger(L,5);//裁剪宽度
	int h=g_ImageLib[id]->GetHeight();
	if(dx==0)//无裁剪
	{
		g_ImageLib[id]->Draw(g_BufDC.GetSafeHdc(),x,y);
	}
	else //裁剪一区间
	{
		RECT clipRect={x,y,dx+x,h+y}; //CxImage裁剪矩形是相对整个DC的
		x-=cx; //裁剪起点移动到当前位置
		g_ImageLib[id]->Draw(g_BufDC.GetSafeHdc(),x,y,-1,-1,&clipRect);
	}
	return 0;
}

int drawImageR(lua_State* L)//lua调用此函数在指定位置绘制库编号为id的图片，参数为(int id , int x , int y, int sx,int sy,int dx,int dy)
{
	int id=lua_tointeger(L,1);
	int x=lua_tointeger(L,2);
	int y=lua_tointeger(L,3);
	int sx=lua_tointeger(L,4);
	int sy=lua_tointeger(L,5);
	int dx=lua_tointeger(L,6);
	int dy=lua_tointeger(L,7);
	
	RECT clipRect={x,y,dx+x,dy+y}; //CxImage裁剪矩形是相对整个DC的
	x-=sx; //裁剪起点移动到当前位置
	y-=sy;
	g_ImageLib[id]->Draw(g_BufDC.GetSafeHdc(),x,y,-1,-1,&clipRect);
	return 0;
}

int drawPoint(lua_State* L)
{
	int x=lua_tointeger(L,1);
	int y=lua_tointeger(L,2);
	int color=lua_tointeger(L,3);
	g_BufDC.SetPixel(x,y,color);
	return 0;
}

int drawLine(lua_State* L)
{
	int x1=lua_tointeger(L,1);
	int y1=lua_tointeger(L,2);
	int x2=lua_tointeger(L,3);
	int y2=lua_tointeger(L,4);
	g_BufDC.MoveTo(x1,y1);
	g_BufDC.LineTo(x2,y2);
	return 0;
}

int drawSolidRect(lua_State* L)
{
	int x1=lua_tointeger(L,1);
	int y1=lua_tointeger(L,2);
	int x2=lua_tointeger(L,3);
	int y2=lua_tointeger(L,4);
	int color=lua_tointeger(L,5);
	g_BufDC.FillSolidRect(x1,y1,x2,y2,color);
	return 0;
}

int drawText(lua_State* L)
{
	int x=lua_tointeger(L,1);
	int y=lua_tointeger(L,2);
	CString text=lua_tostring(L,3);
	g_BufDC.TextOut(x,y,text,text.GetLength());
	return 0;
}

int drawTextR(lua_State* L)
{
	CString str=lua_tostring(L,1);
	int x1=lua_tointeger(L,2);
	int y1=lua_tointeger(L,3);
	int x2=lua_tointeger(L,4);
	int y2=lua_tointeger(L,5);
	int format=lua_tointeger(L,6);
	RECT rect={x1,y1,x2,y2};
	g_BufDC.DrawText(str,&rect,format);
	return 0;
}


int setImageScale(lua_State*L)
{
	int id=lua_tointeger(L,1);
	double scale=lua_tonumber(L,1);
	int w=g_ImageLib[id]->GetWidth();
	int h=g_ImageLib[id]->GetHeight();
	g_ImageLib[id]->Resample(w*scale,h*scale);
	return 0;
}

int setCursor(lua_State* L)
{
	CString name=lua_tostring(L,1);
	g_Cur=(HCURSOR)LoadImage(AfxGetInstanceHandle(),name,IMAGE_CURSOR,0,0,LR_LOADFROMFILE);
	g_setMyCur=true;
	SetCursor(g_Cur);
	return 0;
}

int getImageW(lua_State* L)
{
	int id=lua_tointeger(L,1);
	lua_pushinteger(L,g_ImageLib[id]->GetWidth());
	return 1;
}

int getImageH(lua_State* L)
{
	int id=lua_tointeger(L,1);
	lua_pushinteger(L,g_ImageLib[id]->GetHeight());
	return 1;
}

int setPen(lua_State* L)//lua调用此函数设置画笔参数 (颜色，宽度)
{
	g_LineColor=lua_tointeger(L,1);
	int weight=lua_tointeger(L,2);
	g_Pen.Detach();
	g_Pen.CreatePen(PS_SOLID,weight,g_LineColor);
	CPen* p=g_BufDC.SelectObject(&g_Pen);
	p->DeleteObject(); //释放原对象
	return 0;
}

int setBrush(lua_State* L)
{
	g_BrushColor=lua_tointeger(L,1);
	g_Brush.Detach();
	g_Brush.CreateSolidBrush(g_BrushColor);
	CBrush* p=g_BufDC.SelectObject(&g_Brush);
	p->DeleteObject();
	return 0;
}

int setTextColor(lua_State*L)
{
	int color=lua_tointeger(L,1);
	g_BufDC.SetTextColor(color);
	return 0;
}

int setFont(lua_State* L)
{
	CString font=lua_tostring(L,1);
	int size=lua_tointeger(L,2);
	g_Font.Detach();
	g_Font.CreateFont(size, 
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
		font); 
	CFont* p=(CFont*)g_BufDC.SelectObject(&g_Font);
	p->DeleteObject();
	return 0;
}

int drawRect(lua_State* L)
{
	int x1=lua_tointeger(L,1);
	int y1=lua_tointeger(L,2);
	int x2=lua_tointeger(L,3);
	int y2=lua_tointeger(L,4);
	g_BufDC.Rectangle(x1,y1,x2,y2);
	return 0;
}

int delImage(lua_State* L)//lua调用此函数删除编号为id的图片
{
	int id=lua_tointeger(L,1);
	if(id<0 || id>g_nImage-1)
	{
		MessageBox(NULL,"delImage出错：Lua脚本提供的id超过了有效范围","提示",0);
		return 0;
	}
	delete g_ImageLib[id]; //销毁id处的对象
	g_nImage--; 
	for(int i=id;i<g_nImage;i++)
		g_ImageLib[i]=g_ImageLib[i+1]; //重排线性表
	return 0;
}

int setClock(lua_State* L) //lua调用此函数设置时钟周期
{
	int dt=lua_tointeger(L,1);   //传入的时钟周期(ms)
	g_DT=dt;
	g_pView->KillTimer(666);
	g_pView->SetTimer(666,g_DT,NULL);
	return 0;
}

int setGameName(lua_State* L)
{
	CString str;
	str=lua_tostring(L,1);
	g_pWnd->SetWindowTextA(str);
	return 0;
}

int setNetOption(lua_State* L)
{
	g_connectTOT=lua_tointeger(L,1);
	g_sendTOT=lua_tointeger(L,2);
	g_receiveTOT=lua_tointeger(L,3);
	g_retryTime=lua_tointeger(L,3);
	return 0;
}

///////窗口尺寸////////
int setCanvas(lua_State* L)//lua调用此函数设置画布大小
{
	g_Width=lua_tointeger(L,1);
	g_Height=lua_tointeger(L,2);
	g_BufBMP.Detach();
	g_BufBMP.CreateCompatibleBitmap(g_pView->GetDC(),g_Width,g_Height);
	CBitmap* p=(CBitmap*)g_BufDC.SelectObject(&g_BufBMP);
	p->DeleteObject();
	//计算新的窗口尺寸
	int w=GetSystemMetrics(SM_CXFRAME)+g_Width;
	int h=GetSystemMetrics(SM_CYCAPTION)+GetSystemMetrics(SM_CYFRAME)+g_Height;
	g_pWnd->SetWindowPos(NULL,0,0,w,h,SWP_NOMOVE);
	DrawGame();
	return 0;
}

int getNetText(lua_State* L)
{
	CInternetSession netSession;
	CString url=lua_tostring(L,1);
	CString line;
	CString res;
	
	netSession.SetOption(INTERNET_OPTION_CONNECT_TIMEOUT,g_connectTOT);          //连接超时
	netSession.SetOption(INTERNET_OPTION_SEND_TIMEOUT,   g_sendTOT);             //发送超时
	netSession.SetOption(INTERNET_OPTION_RECEIVE_TIMEOUT,g_receiveTOT);          //接收超时
	netSession.SetOption(INTERNET_OPTION_DATA_SEND_TIMEOUT,g_sendTOT);           //数据发送超时
	netSession.SetOption(INTERNET_OPTION_DATA_RECEIVE_TIMEOUT,g_receiveTOT);     //数据接收超时
	netSession.SetOption(INTERNET_OPTION_CONNECT_RETRIES, g_retryTime);          //重试次数

	try
	{
		DWORD  dwFlag = INTERNET_FLAG_TRANSFER_BINARY|INTERNET_FLAG_RELOAD ;
		CHttpFile* pFile=(CHttpFile*)netSession.OpenURL(url,1,dwFlag);
		if(pFile)
		{
			while(pFile->ReadString(line))
				res+=line;
			/*char strBuf[512]={0};
			while(pFile->Read(strBuf,512))
				res=res+strBuf;*/
			pFile->Close();
			delete pFile;
		}
	}
	catch(CInternetException* e)
	{
	   res="网络资源获取失败";    
	   e->Delete();
	}
	netSession.Close();
    lua_pushstring(L,res);
    return 1;
}

int getNetFile(lua_State* L)
{
    CInternetSession netSession;
	CString strURL=lua_tostring(L,1);
	CString strFN=lua_tostring(L,2);
	BOOL bSucceed = TRUE;

	netSession.SetOption(INTERNET_OPTION_CONNECT_TIMEOUT,g_connectTOT);          //连接超时
	netSession.SetOption(INTERNET_OPTION_SEND_TIMEOUT,   g_sendTOT);             //发送超时
	netSession.SetOption(INTERNET_OPTION_RECEIVE_TIMEOUT,g_receiveTOT);          //接收超时
	netSession.SetOption(INTERNET_OPTION_DATA_SEND_TIMEOUT,g_sendTOT);           //数据发送超时
	netSession.SetOption(INTERNET_OPTION_DATA_RECEIVE_TIMEOUT,g_receiveTOT);     //数据接收超时
	netSession.SetOption(INTERNET_OPTION_CONNECT_RETRIES, g_retryTime);          //重试次数
	try
	{
		CStdioFile * pFile = netSession.OpenURL(strURL); //由于需要按二进制存储，这里采用标准文件对象

		if(pFile != NULL)
		{

			CFile cf;
			if(!cf.Open(strFN, CFile::modeCreate | CFile::modeWrite, NULL))
			{
				MessageBox(NULL,"创建本地文件失败，请检查路径是否合法或权限是否允许!","提示",0);
				return 0;
			}

			BYTE Buffer[512];
			ZeroMemory(Buffer, sizeof(Buffer));
			int nReadLen = 0;

			while((nReadLen = pFile->Read(Buffer, sizeof(Buffer))) > 0)
			{
				cf.Write(Buffer, nReadLen);
			}

			cf.Close();
			pFile->Close() ;
			delete pFile;
		}
	}
	catch (CInternetException* e)
	{
        e->Delete();
		bSucceed=FALSE;
	}
	netSession.Close() ;
	if(!bSucceed)
		DeleteFile(strFN);
    return 0;
}

int utf8ToGB2312(lua_State* L)
{
	CString utfStr=lua_tostring(L,1);
	CString gbStr;
	UTF8ToGB2312(utfStr,gbStr);
	lua_pushstring(L,gbStr);
	return 1;
}

int unicodeToGB2312(lua_State* L)
{
	WCHAR* uniStr=(WCHAR*)lua_tostring(L,1);
	CString gbStr;
	UnicodeToGB2312(uniStr,gbStr);
	lua_pushstring(L,gbStr);
	return 1;
}
//lua启动一个线程
int beginThread(lua_State* L)
{
	int* pID=new int;
    *pID=lua_tointeger(L,1);  //线程编号(0-31)
	g_threadName=lua_tostring(L,2);
	g_stateGroup[*pID]=lua_newthread(g_Box.m_Lua);
	g_threadGroup[*pID]=AfxBeginThread(luaThread,pID);
	return 0;
}

int exitGame(lua_State* L)
{
	PostQuitMessage(0);
    return 0;
}

///////音乐接口////////
int addMusic(lua_State* L)
{
	CString str;
	str=lua_tostring(L,1);
	int id=g_Music.addMusic(str);
	lua_pushinteger(L,id);
	return 1;
}

int delMusic(lua_State* L)
{
	int id=lua_tointeger(L,1);
    g_Music.del(id);
	return 0;
}

int playMusic(lua_State* L)
{
	int id=lua_tointeger(L,1);
	g_Music.play(id);
	return 0;
}

int stopMusic(lua_State* L)
{
	int id=lua_tointeger(L,1);
	g_Music.stop(id);
	return 0;
}

int pauseMusic(lua_State* L)
{	
	int id=lua_tointeger(L,1);
    g_Music.pause(id);
	return 0;
}

int resumeMusic(lua_State* L)
{
	int id=lua_tointeger(L,1);
	g_Music.resume(id);
	return 0;
}

/////////宿主程序的工具函数///////////////
//读取文本文件
CString LoadLuaFile(CString fileName)
{
	CFile luaFile(fileName,CFile::modeRead);   
	CArchive ar(&luaFile,CArchive::load);
	CString Code,str;
	while(ar.ReadString(str))  //载入脚本字符
	{
		Code+=str;     //ReadString不会读入换行符
		Code+="\n";   //如果不加换行符号则无法解析注释后面的程序
	}
	ar.Close();
	luaFile.Close();
	return Code;
}
//UTF8转GB2312码
void UTF8ToGB2312(CString utfStr,CString& gbStr) //UTF-8是一种短字符编码，故采用MultiByteToWideChar计算与转换，转换后的GB码也是多字节字符集，MultiByteToWideChar函数名只强调转换前的格式
{ 
	int n=MultiByteToWideChar(CP_UTF8,0,utfStr,utfStr.GetLength(),NULL,0); //第一次调用此函数获取转换后的长度，第一个参数指定了源编码格式
	WCHAR * pChar = new WCHAR[n+1]; //分配目标字串空间
	n=MultiByteToWideChar(CP_UTF8,0,utfStr,utfStr.GetLength(),pChar,n); //第二次调用传入pChar进行实际转换
	pChar[n]=0; 
	gbStr=pChar;
	delete pChar;
}
//Unicode转GB2312码
void UnicodeToGB2312(LPCWSTR uniStr,CString& gbstr)
{
    int n=WideCharToMultiByte(CP_ACP,NULL,uniStr,-1,NULL,0,NULL,NULL); //第一个参数指定了目标编码格式
	char* pChar=new char[n+1];
	n=WideCharToMultiByte(CP_ACP,NULL,uniStr,-1,pChar,n,NULL,NULL);
	pChar[n]=0;
	gbstr=pChar;
	delete pChar;
}

//广义线程
UINT luaThread(LPVOID pParam)
{
	int* pID=(int*)pParam;
    //lua_State* tempState=lua_newthread(g_Box.m_Lua);
	char threadName[128]={0};
	memcpy(threadName,g_threadName,g_threadName.GetLength());
	lua_getglobal(g_stateGroup[*pID],threadName);    //加载函数
	lua_pcall(g_stateGroup[*pID],0,0,0);             //调用当前函数，p2:参数个数，p3:返回个数

	DWORD ExitCode=0;
	GetExitCodeThread( g_threadGroup[*pID]->m_hThread,&ExitCode);
	//p为需要销毁的CWindThreadZ指针,其在创建线程时可以拿到.
	if(ExitCode>0 )
		AfxEndThread(ExitCode,true);
	delete pID;
	return 0;
}
//////////////View类的成员函数//////////////////////

CGamePainterView::~CGamePainterView()
{
	for(int i=0;i<g_nImage;i++)  //销毁所有图片对象
		delete g_ImageLib[i];
	free(g_ImageLib);    //释放图片库
}

BOOL CGamePainterView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: 在此处通过修改
	//  CREATESTRUCT cs 来修改窗口类或样式
	ModifyStyle(0,BS_OWNERDRAW);
	return CView::PreCreateWindow(cs);
}


#ifdef _DEBUG
void CGamePainterView::AssertValid() const
{
	CView::AssertValid();
}

void CGamePainterView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CGamePainterDoc* CGamePainterView::GetDocument() const // 非调试版本是内联的
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CGamePainterDoc)));
	return (CGamePainterDoc*)m_pDocument;
}
#endif //_DEBUG

///////////////////////////// CGamePainterView 消息处理程序/////////////////////////////////////////////////

void CGamePainterView::OnSize(UINT nType, int cx, int cy) //窗口改变大小时更新全局尺寸信息
{
	g_Width=cx;
	g_Height=cy;
	CView::OnSize(nType, cx, cy);
}

void CGamePainterView::OnTimer(UINT_PTR nIDEvent)  //游戏时钟，每一个周期调用控制脚本GameLoop程序一次
{
	g_Box.callVoidFunc("GameLoop");
	CView::OnTimer(nIDEvent);
}

void CGamePainterView::OnRButtonDown(UINT nFlags, CPoint point)
{
	g_Box.loadFunc("OnRDown");
	g_Box.pushInt(point.x);
	g_Box.pushInt(point.y);
    g_Box.callAnyFunc(2,0);
	CView::OnRButtonDown(nFlags, point);
}

void CGamePainterView::OnLButtonDown(UINT nFlags, CPoint point)
{
	g_Box.loadFunc("OnLDown");
	g_Box.pushInt(point.x);
	g_Box.pushInt(point.y);
	g_Box.callAnyFunc(2,0);
	CView::OnLButtonDown(nFlags, point);
}

void CGamePainterView::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	g_Box.loadFunc("OnLDoubleClick");
	g_Box.pushInt(point.x);
	g_Box.pushInt(point.y);
	g_Box.callAnyFunc(2,0);
	CView::OnLButtonDblClk(nFlags, point);
}

BOOL CGamePainterView::OnMouseWheel(UINT nFlags, short zDelta, CPoint pt)
{
	g_Box.loadFunc("OnMouseWheel");
	g_Box.pushInt(pt.x);
	g_Box.pushInt(pt.y);
	g_Box.pushInt(zDelta);  //滚动量
	g_Box.callAnyFunc(3,0); 
	return CView::OnMouseWheel(nFlags, zDelta, pt);
}

void CGamePainterView::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags) //nRepCnt:键被重击的次数
{
	g_Box.loadFunc("OnVKeyDown");
	g_Box.pushInt(nChar); //虚拟码
	g_Box.pushInt(nRepCnt);//重复次数
	g_Box.callAnyFunc(2,0);//虚拟键处理
	CView::OnKeyDown(nChar, nRepCnt, nFlags);
}

void CGamePainterView::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	g_Box.loadFunc("OnCKeyDown");
	g_Box.pushInt(nChar); //字符键
	g_Box.pushInt(nRepCnt);//重复次数
	g_Box.callAnyFunc(2,0); //字符键处理
	CView::OnChar(nChar, nRepCnt, nFlags);
}

void CGamePainterView::OnMouseMove(UINT nFlags, CPoint point)
{
	g_Box.loadFunc("OnMouseMove");
	g_Box.pushInt(point.x);
	g_Box.pushInt(point.y);
	g_Box.callAnyFunc(2,0);
	CView::OnMouseMove(nFlags, point);
}

void CGamePainterView::OnLButtonUp(UINT nFlags, CPoint point)
{
	g_Box.loadFunc("OnLUp");
	g_Box.pushInt(point.x);
	g_Box.pushInt(point.y);
	g_Box.callAnyFunc(2,0);
	CView::OnLButtonUp(nFlags, point);
}

BOOL CGamePainterView::OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message)
{
	if(g_setMyCur)
	{
		SetCursor(g_Cur);
		return TRUE;
	}
	return CView::OnSetCursor(pWnd, nHitTest, message);
}

