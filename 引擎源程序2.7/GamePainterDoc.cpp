/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "stdafx.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CGamePainterDoc

IMPLEMENT_DYNCREATE(CGamePainterDoc, CDocument)

BEGIN_MESSAGE_MAP(CGamePainterDoc, CDocument)
END_MESSAGE_MAP()


// CGamePainterDoc 构造/析构

CGamePainterDoc::CGamePainterDoc()
{
	// TODO: 在此添加一次性构造代码

}

CGamePainterDoc::~CGamePainterDoc()
{
}

BOOL CGamePainterDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: 在此添加重新初始化代码
	// (SDI 文档将重用该文档)

	return TRUE;
}




// CGamePainterDoc 序列化

void CGamePainterDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: 在此添加存储代码
	}
	else
	{
		// TODO: 在此添加加载代码
	}
}


// CGamePainterDoc 诊断

#ifdef _DEBUG
void CGamePainterDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CGamePainterDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG


// CGamePainterDoc 命令
