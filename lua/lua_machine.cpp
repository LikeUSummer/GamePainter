// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#include "lua_machine.h"

#include <fstream>
#include <sstream>

LuaMachine::LuaMachine()
{
    lua_state_ = luaL_newstate();
    luaL_openlibs(lua_state_);
}

LuaMachine::~LuaMachine()
{
    if (lua_state_) {
        lua_close(lua_state_);
    }
}

bool LuaMachine::LoadScript(const std::string& script)
{
    int err = luaL_loadbuffer(lua_state_, script.c_str(), script.length(), "line") ||
        lua_pcall(lua_state_, 0, 0, 0);
    if (err) {
        errorCode_ = Error::COMPILE_FAILED;
        errorInfo_ = lua_tostring(lua_state_, -1);
        lua_pop(lua_state_, 1);
        return false;
    }
    return true;
}

bool LuaMachine::LoadScriptFromFile(const std::string& filePath)
{
    std::fstream file(filePath);
    std::stringstream ss;
    ss << file.rdbuf();
    return LoadScript(ss.str());
}

void LuaMachine::Top(int& value)
{
    value = lua_tointeger(lua_state_, -1);
}

void LuaMachine::Top(double& value)
{
    value = lua_tonumber(lua_state_, -1);
}

void LuaMachine::Top(std::string& value)
{
    value = lua_tostring(lua_state_, -1);
}

bool LuaMachine::LoadSymbol(const std::string& name)
{
    lua_getglobal(lua_state_, name.c_str());
    if (!lua_gettop(lua_state_)) { // 堆栈为空，说明变量不存在
        errorCode_ = Error::SYMBOL_NOT_FOUND;
        errorInfo_ += "undefined variable " + name;
        return false;
    }
    return true;
}

void LuaMachine::Push()
{
    return;
}

// 调用无参无返回值的空函数
bool LuaMachine::Call(const std::string& name)
{
    return Call(name, 0);
}

// 向 Lua 注册 C 函数
void LuaMachine::RegisterFunction(const std::string& name, lua_CFunction function)
{
    lua_register(lua_state_, name.c_str(), function);
}

// 向 Lua 注册 C 函数库
void LuaMachine::RegisterLibrary(const std::string& name, const luaL_Reg* lib)
{
    luaL_register(lua_state_, name.c_str(), lib);
}
