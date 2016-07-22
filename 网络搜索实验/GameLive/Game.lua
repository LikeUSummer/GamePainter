--游戏控制脚本主框架，控制GamePainter程序进行绘制和表达
--脚本中必须含有GameLoop()函数，每过一个时钟周期GamePainter调用它一次
package.path = package.path..";GameLive/?.lua;"
require("Painter") --GamePainter传递的C函数库
require("Define") --全局常量/变量
require("World")  --世界管理器
require("Searcher")
require("SlideBar")
------框架主程序-------
textX=200
textY=100
Exiting=0
text="当前未接收任何网络文本"
timer=50

function thread1()
	urls={}
	urls[1]={}
	urls[1]="http://news.baidu.com"
	text="正在搜索..."
	--SingleJump("http://www.sina.com.cn",3)
	MultiJump(urls,4)
	text="搜索完成"
--[[
  while Exiting==0 do
     if timer==50 then
	     Search(nextURL,1)
		 timer=0
	 end
  end
  --]]
end

function GameInit()  --初始化函数(接口函数)
  require("Res")
  Painter.setCanvas(1280,720)
  Painter.setTextColor(RGB(179,177,137))
  Painter.setPen(RGB(20,100,220),2)
  Painter.setGameName("网络实验")
  Painter.setCursor("GameRes/Cursor/blue.cur")
  Painter.playMusic(Res.MUSIC_SUMMER)
  --Painter.setNetOption(1000,1000,1000,2)   --这里可以设置网络访问超时等待和重复次数，默认是5s/1次
  --------------------------------------
  local slider=SlideBar:new(1230,30)
  slider.onSlide=function(y)  textY=-y*10+380 end
  world:add(slider)
  Painter.beginThread(0,"thread1")--启动搜索线程
 -- Painter.getNetFile("http://www.baidu.com","C://baidu.html") --下载并保存文件
end

function GameLoop() --游戏主循环函数(接口函数)
  Painter.drawImage(Res.BACK,0,0,0,0)
  for k,obj in pairs(world.Active) do
     obj:update()
  end

  --timer=timer+1
  Painter.drawTextR(g_curPage,textX+100,textY+80,textX+850,1000,0x2010)
  Painter.drawTextR(g_keywordURLs,0,textY+90,300,1000,0x2010)
  Painter.drawText(0,textY,text)
  Painter.drawText(0,textY+30,"当前URL: "..g_nowURL.."  下一跳URL:"..g_nextURL)
  Painter.drawText(0,textY+60,"统计结果: 出现"..g_keyWord.."的次数为"..tostring(g_wordStatistics))

  Painter.updateCanvas()
end

function OnLDown(x,y) --鼠标左键按下(接口函数)
    for k,obj in pairs(world.Active) do
	if obj.onLDown then
     obj:onLDown(x,y)
	 end
    end
end

function OnLUp(x,y)--鼠标左键释放(接口函数)
    for k,obj in pairs(world.Active) do
	if obj.onLUp then
     obj:onLUp(x,y)
	 end
  end
end

--为了运行效率，建议对象不直接处理鼠标移动消息
function OnMouseMove(x,y)  --鼠标移动消息(接口函数)
   MX=x
   MY=y
end

function OnRDown(x,y) --鼠标右键按下(接口函数)
    for k,obj in pairs(world.Active) do
	if obj.onRDown then
      obj:onRDown(x,y)
	 end
   end
end

function OnLDoubleClick(x,y) --鼠标左键双击(接口函数)

end

function OnMouseWheel(x,y,nDelta) --鼠标轮滚动(接口函数)
	      textY=textY+nDelta
end

function OnVKeyDown(nKey,nRep) --虚拟键按下(接口函数)

end

function OnCKeyDown(nKey,nRep) --字符键按下(接口函数)
   for k,obj in pairs(world.Active) do
      if obj.onCKeyDown then
	     obj:onCKeyDown(nKey,nRep)
	  end
   end
end

function OnExit() --程序结束退出时(接口函数)
    Exiting=1
end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015






