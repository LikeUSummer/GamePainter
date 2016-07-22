--固定面板控件
require("UI")

Board=UI:new()

function Board:new(x,y,text)
    local obj={}
	obj.x=x
	obj.y=y
	obj.text=text
	obj.image={}
	obj.imgID=Res.PAPER
	obj.child={} --子控件集
	setmetatable(obj,self)
	self.__index=self
	return obj
end

function Board:draw()
	Painter.setFont("微软雅黑",30)
	Painter.setTextColor(RGB(220,220,100))		
	Painter.drawImage(self.imgID,self.x,self.y,0,0)
	Painter.drawText(self.x+50,self.y+16,self.text)
end