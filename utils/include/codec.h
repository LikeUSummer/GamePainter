// 东方盛夏 2022
// https://www.zhihu.com/people/da-xia-tian-60
#ifndef CODEC_H
#define CODEC_H
#include <string>

std::wstring UTF8ToWide(const std::string& text);
std::string WideToUTF8(const std::wstring& wideText);
#endif
