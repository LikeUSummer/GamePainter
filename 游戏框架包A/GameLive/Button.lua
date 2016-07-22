--按钮基类
require("UI")
Button=UI:new()

function Button:new(x,y,rx,ry)
   local obj={}
	 obj.x=x  --绘图坐标
	 obj.y=y
     obj.rx=rx  --偏移坐标（用于子控件）
     obj.ry=ry
	 
     obj.imgID=Res.BTN_CHECK 
	 obj.frame=1
     obj.width=45
     obj.height=24
	 
     obj.enable=1
	 
	 obj.mDown=0
     obj.onClick={} --回调函数

     obj.child={}    --子控件表
     obj.nChild=0  --子控件数量
   setmetatable(obj,self)
   self.__index=self
   return obj
end

function Button:onLDown(x,y)
if IN_BOX(x,y,self.x,self.y,self.width,self.height)==1 then
    self.frame=2
    self.mDown=1
end
end

function Button:onLUp(x,y)
	self.mDown=0
	self.frame=1
if IN_BOX(x,y,self.x,self.y,self.width,self.height)==1 then
   self:onClick()
end
end

--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
