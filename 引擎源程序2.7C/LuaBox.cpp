/*
程序开源，请勿用于商业开发
怎么去拥有一道彩虹，怎么去拥抱一夏天的风    大夏天2015冬
*/

#include "stdafx.h"
#include "LuaBox.h"

int LuaError=0;
CString LuaErrInfo;

CLuaBox::CLuaBox()
{
	m_Lua = lua_open();    //初始化Lua   
	luaL_openlibs(m_Lua);  //载入Lua基本库
}

CLuaBox::~CLuaBox()
{
	lua_close(m_Lua);   //关闭Lua
}

bool CLuaBox::initText(CString Code)
{
	int err=luaL_loadbuffer(m_Lua,Code,Code.GetLength(),"line") || lua_pcall(m_Lua,0,0,0);//加载Lua程序字符串
	if(err)
	{
		LuaErrInfo=lua_tostring(m_Lua,-1);
		lua_pop(m_Lua,1);
		return false;
	}
	return true;
}

int CLuaBox::getInteger(char* name)
{
	lua_getglobal(m_Lua,name); 
	if(!lua_gettop(m_Lua))  //堆栈为空，说明变量不存在
	{
		LuaError=9;
		LuaErrInfo.Format("未找到名为'%s'的变量",name);
		return 0;
	}
	else
	{
		int val=lua_tointeger(m_Lua,-1);
		lua_pop(m_Lua,1);
		return val;
	}
}

double CLuaBox::getNumber(char* name)
{
	lua_getglobal(m_Lua,name); 
	if(!lua_gettop(m_Lua))  //堆栈为空，说明变量不存在
	{
		LuaError=9;
		LuaErrInfo.Format("未找到名为'%s'的变量",name);
		return 0;
	}
	else
	{
		double val=lua_tonumber(m_Lua,-1);
		lua_pop(m_Lua,1);
		return val;
	}
}

CString CLuaBox::getString(char* name)
{
   lua_getglobal(m_Lua,name);
   if(!lua_gettop(m_Lua))  //堆栈为空，说明变量不存在
   {
	   LuaError=9;
	   LuaErrInfo.Format("未找到名为'%s'的变量",name);
	   return 0;
   }
   else
   {
	   CString val=lua_tostring(m_Lua,-1);
	   lua_pop(m_Lua,1);
	   return val;
   }
}

void CLuaBox::pushInt(int m)
{
	lua_pushinteger(m_Lua,m);
}
void CLuaBox::pushStr(char* m)
{
	lua_pushstring(m_Lua,m);
}
void CLuaBox::pushNum(double m)
{
	lua_pushnumber(m_Lua,m);
}

void CLuaBox::loadFunc(char* name)
{
	lua_getglobal(m_Lua,name);    //加载函数
}
//调用任意函数，参数自行压栈，返回值自行接收
void CLuaBox::callAnyFunc(int nPara,int nRet)
{
	LuaError=lua_pcall(m_Lua,nPara,nRet,0);  //调用当前函数，p2:参数个数，p3:返回个数

	if(LuaError)
	{
		LuaErrInfo=lua_tostring(m_Lua, -1);//打印错误结果 
		lua_pop(m_Lua, 1);
	}
}

//调用纯空Lua函数
void CLuaBox::callVoidFunc(char* name) 
{
	lua_getglobal(m_Lua,name);    //加载函数
	LuaError=lua_pcall(m_Lua,0,0,0);            //调用当前函数，p2:参数个数，p3:返回个数

	if(LuaError)
	{
		LuaErrInfo=lua_tostring(m_Lua, -1);//打印错误结果 
		lua_pop(m_Lua, 1);
	}
}

//调用返回整数的无参函数
int CLuaBox::callIntFunc(char* name)
{
	lua_getglobal(m_Lua,name);    //加载函数
	LuaError=lua_pcall(m_Lua,0,1,0);            //调用当前函数，p2:参数个数，p3:返回个数

	if(LuaError)
	{
		LuaErrInfo=lua_tostring(m_Lua, -1);//打印错误结果 
		lua_pop(m_Lua, 1);
	}

	int r=lua_tointeger(m_Lua,-1);
	lua_pop(m_Lua,1);
	return r;
}

//向Lua注册C函数
void CLuaBox::regFunc(char* name,lua_CFunction address)
{
	lua_register(m_Lua,name,address);
}
//向Lua注册C函数库
void CLuaBox::regFuncLib(char* libName,const luaL_Reg* Lib)
{
	luaL_register(m_Lua,libName,Lib);
}

///////////////////为了增强功能，引入全局变量与函数操作lua//////////////////////
//以下是全局变量
char** g_StrArr;
double* g_NumArr;
int* g_IntArr;
int g_ArrCount;
int g_ArrType;
#define ARR_TYPE_STR 0
#define ARR_TYPE_NUM 1
#define ARR_TYPE_INT 2
//以下是全局函数
void setTableInfo(int arrCount,int arrType)
{
    g_ArrCount=arrCount;
	g_ArrType=arrType;
}

int getTable(lua_State *L)          //向lua传递数组
{  
	int i;
	lua_newtable(L);  
    if(g_ArrType==ARR_TYPE_NUM)
		for(i=0; i<g_ArrCount; i++)  
		{  
			lua_pushnumber(L, i+1);  
			lua_pushnumber(L, g_NumArr[i]);  
			lua_settable(L, -3);  
		}  
	else if(g_ArrType==ARR_TYPE_INT)
		for(i=0; i<g_ArrCount; i++)  
		{  
			lua_pushnumber(L, i+1);  
			lua_pushnumber(L, g_IntArr[i]);  
			lua_settable(L, -3);  
		}  
	else if(g_ArrType==ARR_TYPE_STR)
		for(i=0; i<g_ArrCount; i++)  
		{  
			lua_pushnumber(L, i+1);  
			lua_pushstring(L, g_StrArr[i]);  
			lua_settable(L, -3);  
		}  
	return 1;  
}  

//待注册的C函数库，每一项是个luaL_Reg结构体，注意以{NULL,NULL}结尾
const luaL_Reg g_CLib[] = {  
	{"getTable", getTable},  
	{NULL, NULL}  
};  
/*
注册C函数库的语句为
    luaL_register(L, 库名, luaL_Reg数组)
在lua程序中使用时的语句为
    require("库名")
    库名.函数名(...)
*/
