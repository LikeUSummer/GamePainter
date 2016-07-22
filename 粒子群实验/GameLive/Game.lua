--游戏控制脚本主框架，控制GamePainter程序进行绘制和表达
--脚本中必须含有GameLoop()函数，每过一个时钟周期GamePainter调用它一次
package.path = package.path..";GameLive/?.lua;"
require("Painter") --GamePainter传递的C函数库
require("Define") --全局常量/变量
require("World")  --世界管理器
require("Atom")   --粒子实验模块
------框架程序

function GameInit()  --初始化函数(接口函数)
  require("Res")
  Painter.setCanvas(WIDTH,HEIGHT)
  Painter.setTextColor(RGB(20,100,255))
  --刷新频率(ms)，DT在Atom.lua文件中定义，单位是秒，这里使刷新间隔和计算间隔相同可以保证观测同步
  Painter.setClock(DT*1000) --也可不设置，则默认是10帧每秒，这时如果DT可以选择很小以保证计算精度，只是观测时变化会较慢
------------创建世界元素-------------------
  world:add(Atom:new(500,400))

  Painter.playMusic(Res.MUSIC_SUMMER)
  Painter.setGameName("粒子实验")
  Painter.setCursor("GameRes/Cursor/blue.cur")
end

function GameLoop() --游戏主循环函数(接口函数)
  Painter.drawSolidRect(0,0,WIDTH,HEIGHT,RGB(0,0,0)) --背景黑色
  for k,obj in pairs(world.Active) do
     obj:update()
  end
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

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015






