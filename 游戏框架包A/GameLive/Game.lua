--游戏控制脚本主框架，控制GamePainter程序进行绘制和表达
--脚本中必须含有GameLoop()函数，每过一个时钟周期GamePainter调用它一次
package.path = package.path..";GameLive/?.lua;"
require("Painter") --GamePainter传递的C函数库
require("State")   --状态类
require("Define") --全局常量/变量
require("World")  --世界管理器
require("Animation") --动画类
require("Number") --数字类
--------------------------------------------
require("Me") --主角基类
require("MuMu")
require("NPCs")
require("Map")     --地图文件
require("Button")
require("TextBox")
require("Board")
------框架程序

function GameInit()  --初始化函数(接口函数)
  require("Res")
  Painter.setCanvas(WIDTH,HEIGHT)
  Painter.setTextColor(RGB(142,108,69))
  Painter.setBrush(RGB(123,125,200))
------------创建世界元素-------------------
  map=Map:new("GameRes/Image/野外.jpg",0,0,2000,600)
  world:add(map)
  world:add(MuMu:new(400,400))
  world:add(FoodSaler:new(970,318))
  world:add(Me:new(206,400))
  Painter.playMusic(Res.MUSIC_SUMMER)
  Painter.setGameName("梦江湖")
  Painter.setCursor("GameRes/Cursor/blue.cur")
end

function GameLoop() --游戏主循环函数(接口函数)
  Painter.drawSolidRect(0,0,1200,600,RGB(255,255,123))
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






