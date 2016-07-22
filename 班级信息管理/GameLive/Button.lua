--按钮基类
require("UI")
Button=UI:new()

function Button:new(x,y,rx,ry,text)
   local obj={}
	 obj.x=x  --绘图坐标
	 obj.y=y
     obj.rx=rx  --偏移坐标（用于子控件）
     obj.ry=ry
	 obj.text=text or ""
     obj.imgID=Res.BUTTON2
	 obj.frame=1
	 obj.maxFrame=2
     obj.width=90
     obj.height=30
     obj.enable=1
	 obj.mDown=0
     obj.onClick=nil --回调函数

     obj.child={}    --子控件表
     obj.nChild=0  --子控件数量
   setmetatable(obj,self)
   self.__index=self
   return obj
end
function Button:draw()
    Painter.setFont("微软雅黑",20)
	Painter.setTextColor(RGB(230,190,50))
    Painter.drawImage(self.imgID,self.x,self.y,(self.frame-1)*self.width,self.width)
	Painter.drawText(self.x+30,self.y+2,self.text)
end


function Button:onLDown(x,y)
if IN_BOX(x,y,self.x,self.y,self.width,self.height)==1 then
    if self.maxFrame>2 then
        self.frame=3
    end
    self.mDown=1
end
end

function Button:onLUp(x,y)
	self.mDown=0
	self.frame=1
	if IN_BOX(x,y,self.x,self.y,self.width,self.height)==1 then
	   if self.onClick then --必须检测存在性
	      self:onClick()
	   end
	end
end

function  Button:change() 
	if IN_BOX(MX,MY,self.x,self.y,self.width,self.height)==1 then
		if self.maxFrame>1 then
			self.frame=2
		end
	else
	     self.frame=1
	end
end

--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
