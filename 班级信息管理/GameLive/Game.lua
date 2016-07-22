--游戏控制脚本主框架，控制GamePainter程序进行绘制和表达
--脚本中必须含有GameLoop()函数，每过一个时钟周期GamePainter调用它一次
package.path = package.path..";GameLive/?.lua;"
package.cpath = package.cpath..";GameLive/?.dll;"
require("Painter") --GamePainter传递的C函数库
require("Define") --全局常量/变量
require("World")  --世界管理器
require("SlideBar")
require("EditCtrl")
require("Button")
require("TextBox")
require("GridCard")
require("ClassCard")
require("Board")
------框架主程序-------

g_Class={}  --班级浏览卡
g_InfoCard={}  --信息浏览卡
g_RtnButton={}  --返回按钮
g_DelClassButton={}  --删除班级按钮
g_NewCardButton={} --新建按钮
g_NewClassButton={}--新建班级按钮
g_NameEdit={}  --名称编辑框
g_Slider={}  --滑条
g_TitleBoard={}  --标题板
g_InfoChange=false --修改标志
g_DelClass=false
g_Info={} --当前信息库
g_InfoPath=""--当前库路径
function GameInit()  --初始化函数(接口函数)
  require("Res")
  Painter.setCanvas(1280,720)
  Painter.setPen(RGB(20,100,220),2)
  Painter.setGameName("亲爱的同学们")
  Painter.setCursor("GameRes/Cursor/blue.cur")
  Painter.playMusic(Res.MUSIC_SUMMER)
  Painter.setClock(80)
  --------------------------------------
    g_Slider=SlideBar:new(1225,40)
    g_TitleBoard=Board:new(500,20,"班级信息管理工具")
	g_NameEdit=EditCtrl:new(0,0,100,60)
	g_NameEdit.charH=25
    g_Slider.onSlide=function(y)  g_Class.y=-y+160 end
    g_Class=ClassCard:new(150,120,1000,1000)
	g_RtnButton=Button:new(960,650,0,0,"返回")
	g_NewCardButton=Button:new(850,650,0,0,"新建")
	g_NewCardButton.onClick=onNewCard
	g_NewClassButton=Button:new(950,650,0,0,"新建")
	g_NewClassButton.onClick=onNewClass
	g_DelClassButton=Button:new(850,650,0,0,"编辑")
	g_DelClassButton.onClick=function()
	    if g_DelClass==true  then
		   g_DelClass=false
		   g_DelClassButton.text="编辑"
		else
		   g_DelClass=true
		   g_DelClassButton.text="完成"
		end
	end
	g_RtnButton.onClick=function() 
	  if  g_Class.enable==0  then
        g_Slider.onSlide=function(y)  g_Class.y=-y+160 end
		 world:add(g_Class) 
		 g_Class.enable=1
		 world:add(g_NewClassButton)
		 world:add(g_DelClassButton)
		 world:del(g_InfoCard)
		 world:del(g_RtnButton)
		 world:del(g_NewCardButton)
		 if g_InfoChange==true then
		     Painter.beginThread(0,"saveThread")
		 end
	  end
     end
	 world:add(g_Slider)
	 world:add(g_Class)
	 world:add(g_TitleBoard)
	 world:add(g_NewClassButton)
	 world:add(g_DelClassButton)
end

function GameLoop() --游戏主循环函数(接口函数)
  Painter.drawImage(Res.BACK,0,0,0,0)
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

function OnCKeyDown(word,nRep) --字符键按下(接口函数)
   for k,obj in pairs(world.Active) do
      if obj.onCKeyDown then
	     obj:onCKeyDown(word,nRep)
	  end
   end
end

Exiting=0 --退出信号
function OnExit() --程序结束退出时(接口函数)
    Exiting=1
end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015






