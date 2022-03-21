// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#ifndef LUA_MACHINE_H
#define LUA_MACHINE_H

#ifndef LUA_COMPAT_MODULE
#define LUA_COMPAT_MODULE
#endif
extern "C" {
#include "src/lua.h" 
#include "src/lualib.h" 
#include "src/lauxlib.h"
}

#include <map>
#include <string>
#include <vector>

class LuaMachine
{
    enum class Error {
        OK,
        COMPILE_FAILED,
        SYMBOL_NOT_FOUND,
        CALL_FAILED
    };

public:
    lua_State* lua_state_ {nullptr};
    Error errorCode_ {Error::OK};
    std::string errorInfo_;

public:
    LuaMachine();
    ~LuaMachine();

    bool LoadScript(const std::string& Code);
    bool LoadScriptFromFile(const std::string& filePath);
    bool LoadSymbol(const std::string& symbol);

    void Top(int& value);
    void Top(double& value);
    void Top(std::string& value);
    template<typename Type>
    void Pop(Type& value);
    template<typename Type>
    bool Get(const std::string& name, Type& value);

    void Push();
    template<typename... VarType>
    void Push(int value, VarType&&... params);
    template<typename... VarType>
    void Push(const std::string& value, VarType&&... params);
    template<typename... VarType>
    void Push(double value, VarType&&... params);

    template<typename Type, typename... VarType>
    void Push(const std::vector<Type>& list, VarType&&... params);
    template<typename KeyType, typename ValueType, typename... VarType>
    void Push(const std::map<KeyType, ValueType>& map, VarType&&... params);

    template<typename... VarType>
    bool Call(const std::string& name, int returnCount, VarType&&... params);
    bool Call(const std::string& name);

    void RegisterFunction(const std::string& name, lua_CFunction function);
    void RegisterLibrary(const std::string& name, const luaL_Reg* lib);
};

template<typename Type>
void LuaMachine::Pop(Type& value)
{
    Top(value);
    lua_pop(lua_state_, 1);
}

template<typename Type>
bool LuaMachine::Get(const std::string& name, Type& value)
{
    if (LoadSymbol(name)) {
        Pop(value);
        return true;
    }
    return false;
}

template<typename... VarType>
void LuaMachine::Push(int value, VarType&&... params)
{
    lua_pushinteger(lua_state_, value);
    Push(std::forward<VarType>(params)...);
}

template<typename... VarType>
void LuaMachine::Push(const std::string& value, VarType&&... params)
{
    lua_pushstring(lua_state_, value.c_str());
    Push(std::forward<VarType>(params)...);
}

template<typename... VarType>
void LuaMachine::Push(double value, VarType&&... params)
{
    lua_pushnumber(lua_state_, value);
    Push(std::forward<VarType>(params)...);
}

template<typename Type, typename... VarType>
void LuaMachine::Push(const std::vector<Type>& list, VarType&&... params)
{
    lua_newtable(lua_state_);
    for (int i = 0; i < list.size(); ++i) {
        lua_pushinteger(lua_state_, i + 1); // key
        Push(list[i]); // value
        lua_settable(lua_state_, -3);
    }
    Push(std::forward<VarType>(params)...);
}

template<typename KeyType, typename ValueType, typename... VarType>
void LuaMachine::Push(const std::map<KeyType, ValueType>& map, VarType&&... params)
{
    lua_newtable(lua_state_);
    for (auto& item : map) {
        Push(item.first); // key
        Push(item.second); // value
        lua_settable(lua_state_, -3);
    }
    Push(std::forward<VarType>(params)...);
}

template<typename... VarType>
bool LuaMachine::Call(const std::string& name, int returnCount, VarType&&... params)
{
    if (!LoadSymbol(name)) {
        return false;
    }
    Push(std::forward<VarType>(params)...);
    int err = lua_pcall(lua_state_, sizeof...(params), returnCount, 0);
    if (err) {
        errorCode_ = Error::CALL_FAILED;
        errorInfo_ = lua_tostring(lua_state_, -1);
        lua_pop(lua_state_, 1);
        return false;
    }
    return true;
}

#endif