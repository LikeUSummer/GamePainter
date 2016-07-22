--地图基类
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天201self.speed
Map={}
function Map:new(imagePath,x,y,w,h)
    local obj={}
	obj.ID=-1           --对象在世界管理器中的ID
	obj.x=x   --绘图起点
	obj.y=y
	obj.imageID=Painter.addJPG(imagePath)
	obj.width=w
	obj.height=h
	obj.speed=6
	obj.haveMask=0 --有无遮罩
	obj.maskID=-1 --遮罩图ID
    setmetatable(obj,self)  --新建对象
    self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function Map:loadMask(imagePath) --添加路径遮罩
   self.maskID=Painter.addImage(imagePath)
   self.haveMask=1
end

function Map:update()  --更新状态
    self:change()
    self:draw()
end

function Map:draw()
   Painter.drawImage(self.imageID,self.x,self.y,0,0)  --绘制地景
end

function Map:change()
   WX=self.x
   WY=self.y
   if  HX>2*WIDTH/3 then
        if self.width+self.x-self.speed>WIDTH then
		   self.x=self.x-self.speed
		else
		   self.x=WIDTH-self.width
		end
   elseif HX<WIDTH/4 then
        if self.x+self.speed<0 then
		   self.x=self.x+self.speed
		else
		   self.x=0
		end
   end

   if  HY>2*HEIGHT/3 then
        if self.height+self.y-self.speed>HEIGHT then
		   self.y=self.y-self.speed
		else
		   self.y=HEIGHT-self.height
		end
   elseif HY<HEIGHT/4 then
        if self.y+self.speed<0 then
		   self.y=self.y+self.speed
		else
		   self.y=0
		end
   end
end

function Map:maskCheck() --遮罩检测

end

function Map:onRDown(x,y)

end

function Map:onLDown(x,y)

end

function Map:onLUp(x,y)

end
