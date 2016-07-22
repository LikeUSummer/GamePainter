--游戏控制脚本主框架，控制GamePainter程序进行绘制和表达
--脚本中必须含有GameLoop()函数，每过一个时钟周期GamePainter调用它一次
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
package.path = package.path..";GameLive/?.lua;"
require("Painter") --GamePainter传递的C函数库
require("State")   --状态类
require("Define") --全局常量/变量
require("World")  --世界管理器
require("Animation") --动画类
require("UI")   --界面基类
require("Life")    --生命体基类
require("Legend") --角色基类
require("NPC")   --NPC基类
--------------------------------------------
require("Me") --主角基类
require("Monster") --野怪类
require("Mumu")  --野怪阿木木
require("Bear")     --野怪北极熊
require("NPCs")
require("Map")     --地图文件
require("Button")
require("TextBox")
require("Board")
------框架程序
function GameInit()
  require("Res")
  Painter.setCanvas(WIDTH,HEIGHT)
  Painter.setTextColor(RGB(170,160,150))
  Painter.setBrush(RGB(123,125,200))

------------创建世界元素-------------------
  map=Map:new("GameRes/Image/长安城b.jpg",-349,-1225,3800,2438)
  world:add(map)
  world:add(Bear:new(904,1089))
  world:add(MuMu:new(126,2137))
  world:add(FoodSaler:new(803,1637))
  MY_ID=world:add(Me:new(971,1728))
 -- world:add(Board:new(200,395))

  Painter.playMusic(Res.MUSIC_SUMMER);--背景音乐
end

function GameLoop() --游戏主循环函数，必须含有
  Painter.drawSolidRect(0,0,1200,600,RGB(255,255,123))
  for k,obj in pairs(world.Active) do
     obj:update()
  end
  MYSTATE.attacking=0
  Painter.updateCanvas()
end

function OnLDown(x,y) --鼠标左键按下
    for k,obj in pairs(world.Active) do
	if obj.onLDown then
     obj:onLDown(x,y)
	 end
    end
end

function OnLUp(x,y)
    for k,obj in pairs(world.Active) do
	if obj.onLUp then
     obj:onLUp(x,y)
	 end
  end
end

function OnMouseMove(x,y)  --为了运行效率，建议对象不直接处理鼠标移动消息
   MX=x
   MY=y
end

function OnRDown(x,y) --鼠标右键按下
    for k,obj in pairs(world.Active) do
	if obj.onRDown then
     obj:onRDown(x,y)
	 end
   end
end

function OnLDoubleClick(x,y) --鼠标左键双击

end

function OnMouseWheel(x,y,nDelta) --鼠标轮滚动

end

function OnVKeyDown(nKey,nRep) --虚拟键按下

end

function OnCKeyDown(nKey,nRep) --字符键按下
   for k,obj in pairs(world.Active) do
      if obj.onCKeyDown then
	     obj:onCKeyDown(nKey,nRep)
	  end
   end
end







