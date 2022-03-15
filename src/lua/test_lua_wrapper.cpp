// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#include "lua_machine.h"

#include <string>
#include <sstream>
#include <iostream>
#include <map>
#include <vector>

#include <codec.h>

const std::string g_luaScript = R"(
    stringValue = nil
    intValue = nil
    realValue = nil

    function LoadMap(map)
        text = '{'
        for k, v in pairs(map) do
            text = text .. k .. ' : ' .. v .. ', '
        end
        text = string.sub(text, 1, #text - 2)
        text = text .. '}'
        return text
    end

    function LoadList(list)
        text = '{'
        for k, v in ipairs(list) do
            text = text .. v .. ', '
        end
        text = string.sub(text, 1, #text - 2)
        text = text .. '}'
        return text
    end

    function Norm(x, y)
        return math.sqrt(x ^ 2 + y ^ 2)
    end

    function Void()
        text = 'hello lua'
        integer = 1357
        real = 3.1415926
    end

    function Chinese(text)
        return "回首向来萧瑟处 " .. text
    end
)";

int main()
{
    setlocale(LC_CTYPE, ""); // 参数为空串时，会自动获取系统的地域信息
    // std::wcout.imbue(std::locale("")); // 用这种 C++ 库函数设置后，仍然有乱码，原因未知

    std::wstringstream wss;
    std::string text;
    LuaMachine lua;
    if (!lua.LoadScript(g_luaScript)) {
        wss << "[lua compile failed]\n" << UTF8ToWide(lua.errorInfo_);
        std::wcout << wss.str();
        return 0;
    }

    std::map<std::string, std::string> map;
    map.insert({"hello", "world"});
    map.insert({"great", "summer"});
    lua.Call("LoadMap", 1, map);
    lua.Pop(text);
    wss << "LoadMap: " << UTF8ToWide(text) << std::endl;

    std::vector<double> list {3.14159, 2.71828, 1.414};
    lua.Call("LoadList", 1, list);
    lua.Pop(text);
    wss << "LoadList: " << UTF8ToWide(text) << std::endl;

    lua.Call("Norm", 1, 3, 4);
    int result;
    lua.Pop(result);
    wss << "Norm: " << result << std::endl;

    lua.Call("Void");
    int integer;
    double real;
    lua.Get("integer", integer);
    lua.Get("real", real);
    lua.Get("text", text);
    wss << "Void: " << integer << ' ' << real << ' ' << UTF8ToWide(text) << std::endl;

    // 第二个参数等价于 WideToUTF8(_T("也无风雨也无晴"))，这里默认转成的 std:string 也是 UTF-8 编码
    lua.Call("Chinese", 1, "也无风雨也无晴");
    lua.Pop(text);
    wss << "Chinese: " << UTF8ToWide(text) << std::endl;

    std::wcout << wss.str();
    getchar();
    return 0;
}
