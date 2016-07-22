/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "stdafx.h"
#pragma once

#define  MAX_MUSIC  32
class MusicBox
{
public:
	MusicBox(void);
	~MusicBox(void);
private:
	int m_ID[MAX_MUSIC];
	int m_nID;
	MCI_PLAY_PARMS mciPlay;
	MCI_OPEN_PARMS mciOpen;
public:
	int addMusic(CString str);
	void play(int ID);
	void pause(int ID);
	void stop(int ID);
	void resume(int ID);
	void del(int ID);
};
