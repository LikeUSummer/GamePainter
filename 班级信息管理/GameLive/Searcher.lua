g_keyWord="www"  --待搜索词
g_wordStatistics=0  --关键词出现次数
g_keywordURLs="符合分析条件的网址是:\r\n"  --出现过关键词的网址
g_curPage={} --当前页面的文本
g_nextURL="未设置此变量"
g_nowURL="未设置此变量"
g_urlPattern="http://www*%.%w*%.%a*"
function  AnalysePage(url,text) --根据需要分析网页文本text，这里的示例只是统计关键词出现的次数
	 local inPage=false
	 for word in string.gfind(text,g_keyWord) do
          g_wordStatistics=g_wordStatistics+1
		  inPage=true
     end
	 if inPage==true then
	       g_keywordURLs=g_keywordURLs.."\r\n"..url --添加符合的网址
	 end
end

function Search(url) --访问并分析一个网页
        local text=Painter.getNetText(url)
        text=transText(text) 
        g_curPage=text
		AnalysePage(url,text)
end

function SingleJump(url,n)  --单步跳转，每打开一个页面，从中搜索一个不同于本页面地址的网址，作为下一跳，n为跳数
    if n~=0 then 
	    local i,j
        local text=Painter.getNetText(url)
        text=transText(text)	
		g_curPage=text
		g_nowURL=url

		local nextURL=url	
		j=1
		while nextURL==url do
           i,j=string.find(text,g_urlPattern,j)
		   if j==nil then  --无匹配
			      break
		   end
           nextURL=text:sub(i,j)
		 end
		 --------------根据需要分析当前网页------------------
		  AnalysePage(url,text)
		 ------------------------------------------------------
	    SingleJump(nextURL,n-1)--下一跳
	  end
end

function MultiJump(urls,n) --遍历跳转，搜索本页面所有的网址并访问分析，n为跳数
    if n~=0 and #urls>0 then 
	    local i,j
		local unique=true
		local text
		local nextURLs={}
		local nexturl={}
		local nURL=0
		for k,URL in pairs(urls) do
		if  urls[k+1] then
		    g_nextURL=urls[k+1]
		end
			text=Painter.getNetText(URL)
            text=transText(text)
			g_curPage=text
			g_nowURL=URL
		for nexturl in string.gfind(text,"http://www%.%w*%.%a*") do
			    if nexturl~=URL then
				    unique=true
					for k,v in pairs(nextURLs) do
					    if v==nexturl then
						     unique=false
						end
					end
					if unique==true then
			           nURL=nURL+1
					   nextURLs[nURL]={}
				       nextURLs[nURL]=nexturl
					 end
				end
		end

		 --------------根据需要分析当前网页------------------
		    AnalysePage(URL,text)
		 ------------------------------------------------------
		 end
		 MultiJump(nextURLs,n-1)
	  end
end

function transText(text)
        local i
		i=text:find("charset=gb")
		if i then  --gb编码
                   return text
		end
		return Painter.utf8ToGB2312(text)  --utf-8编码
end


function  uniqueTable(urls)
     local hash={}
	 local n=0
        for k,v in pairs(urls) do
			n=0
			for i=1,string.len(v) do
			   n=n+v:byte(i)
			end
			 if  hash[n] then
			    table.remove(urls,k)
			 else
			   table.insert(hash,n,1)
			 end
		end
end