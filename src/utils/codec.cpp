// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#include <codecvt>
#include <iostream>
#include <locale>
#include <memory>

#include "codec.h"

/*
可用“也”字测试各编码转换函数是否正常工作
Unicode	   UTF-8	  GB18030（ANSI本地码）
4E5F       4B99F	      D2B2
std::wstringstream wss;
std::cout << (uint8_t)text[0];
*/
std::wstring UTF8ToWide(const std::string& text)
{
#ifdef WIN32
    int n = MultiByteToWideChar(CP_UTF8, 0, text.c_str(), text.size(), NULL, 0);
    auto wideText = std::make_unique<wchar_t[]>(n + 1);
    n = MultiByteToWideChar(CP_UTF8, 0, text.c_str(), text.size(), wideText.get(), n);
    wideText[n] = 0;
    wchar_t* wideTextFinal = wideText.get();
    if (wideTextFinal[0] == 0xFEFF) {
        ++wideTextFinal; // delete UTF-8 BOM
    }
    return std::wstring(wideTextFinal);
#else
    std::wstring wideText;
    try {
        std::wstring_convert<std::codecvt_utf8<wchar_t>> convert;
        wideText = convert.from_bytes(text);
    } catch (const std::exception & e) {
        std::cout << e.what() << std::endl;
    }
    return wideText;
#endif
}

std::string WideToUTF8(const std::wstring& wideText) {
#ifdef WIN32
    int n = WideCharToMultiByte(CP_UTF8, NULL, wideText.c_str(), -1, NULL, 0, NULL, NULL);
    auto text = std::make_unique<char[]>(n + 1);
    n = WideCharToMultiByte(CP_UTF8, NULL, wideText.c_str(), -1, text.get(), n, NULL, NULL);
    text[n] = 0;
    return std::string(text.get());
#else
    std::string text;
    try {
        std::wstring_convert<std::codecvt_utf8<wchar_t>> convert;
        text = convert.to_bytes(wideText);
    } catch (const std::exception & e) {
        std::cout << e.what() << std::endl;
    }
    return text;
#endif
}

#ifdef WIN32
std::string WideToANSI(const std::wstring& wideText) {
    int n = WideCharToMultiByte(CP_ACP, NULL, wideText.c_str(), -1, NULL, 0, NULL, NULL);
    auto text = std::make_unique<char[]>(n + 1);
    n = WideCharToMultiByte(CP_ACP, NULL, wideText.c_str(), -1, text.get(), n, NULL, NULL);
    text[n] = 0;
    return std::string(text.get());
}
#endif