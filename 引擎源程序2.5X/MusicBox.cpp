/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "StdAfx.h"
#include "MusicBox.h"

MusicBox::~MusicBox(void)
{
}

MusicBox::MusicBox()
{
	mciOpen.lpstrDeviceType="mpegvideo"; //暂时只针对mp3格式
	m_nID=-1;
}

int MusicBox::addMusic(CString name)
{
	m_nID++;
	if(m_nID==MAX_MUSIC)
	{
		MessageBox(NULL,"音乐播放数量超过游戏引擎承载能力","提示",0);
		return -1;
	}

	mciOpen.lpstrElementName=name;
	MCIERROR mciErr;
	mciErr=mciSendCommand(0,MCI_OPEN,MCI_OPEN_TYPE|MCI_OPEN_ELEMENT,(DWORD)&mciOpen);
	if(mciErr)
	{
		char str[128];
		mciGetErrorString(mciErr,str,128);
		MessageBox(NULL,str,"提示",0);
		return -1;
	}
	m_ID[m_nID]=mciOpen.wDeviceID;
	return m_nID;
}

void MusicBox::play(int id)
{
	MCIERROR mciErr=mciSendCommand(m_ID[id],MCI_PLAY,0,(DWORD)&mciPlay);
	if(mciErr)
	{
		char str[128];
		mciGetErrorString(mciErr,str,128);
		MessageBox(NULL,str,"提示",0);
	}
}

void MusicBox::pause(int id)
{
	MCIERROR mciErr=mciSendCommand(m_ID[id],MCI_PAUSE,0,(DWORD)&mciPlay);
	if(mciErr)
	{
		char str[128];
		mciGetErrorString(mciErr,str,128);
		MessageBox(NULL,str,"提示",0);
	}
}

void MusicBox::stop(int id)
{
	MCIERROR mciErr=mciSendCommand(m_ID[id],MCI_STOP,0,(DWORD)&mciPlay);
	if(mciErr)
	{
		char str[128];
		mciGetErrorString(mciErr,str,128);
		MessageBox(NULL,str,"提示",0);
	}
}

void MusicBox::resume(int id)
{
	MCIERROR mciErr=mciSendCommand(m_ID[id],MCI_RESUME,0,(DWORD)&mciPlay);
	if(mciErr)
	{
		char str[128];
		mciGetErrorString(mciErr,str,128);
		MessageBox(NULL,str,"提示",0);
	}
}

void MusicBox::del(int id)  //删除一个音乐设备
{
	MCIERROR mciErr=mciSendCommand(m_ID[id],MCI_CLOSE,0,(DWORD)&mciPlay);
	if(mciErr)
	{
		char str[128];
		mciGetErrorString(mciErr,str,128);
		MessageBox(NULL,str,"提示",0);
	}
	for(int i=id;i<m_nID;i++)
	{
		m_ID[i]=m_ID[i+1];
	}
}