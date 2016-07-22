--动画基类
--[[
参数结构约定：
传入的image为图片信息表，每一个图片元素用{ID,F,FW}组表示
其中F是图片帧数，FW是每帧宽度
用缩写变量是为了尽可能便于书写，否则语句会冗长
--]]
Animation={}

function Animation:new(image)  --传入图像ID表
    local obj={}
    obj.image=image
	obj.lock=0
	obj.actImage=1  --当前图像索引
	obj.actFrame=1 --当前帧
	obj.frameDelay=1  --每帧重复次数，可控制帧率
	obj.frameTime=1   --当前帧已画次数
	setmetatable(obj,self)
	self.__index=self
	return obj
end

function Animation:lockFrame(frame)
   self.lock=1
   self.actFrame=frame
end

function Animation:show(x,y)
    local i=self.actImage
	local sx,sy=self:getFrameXY(self.actFrame)
	Painter.drawImageR(self.image[i].ID,x-self.image[i].dx,y-self.image[i].dy,sx,sy,self.image[i].FW,self.image[i].FH)
	if self.lock==0 then
	   if  self.frameTime<self.frameDelay then
	       self.frameTime=self.frameTime+1
	   else
	       if self.actFrame==self.image[i].XF*self.image[i].YF then
	          self.actFrame=1
	       else
		      self.actFrame=self.actFrame+1
	       end
		   self.frameTime=1
		end
	end
end

function Animation:getFrameXY(frame)
    local i=self.actImage
	local sx=self.image[i].FW*math.floor((frame-1)%self.image[i].XF)
	local sy=self.image[i].FH*math.floor((frame-1)/self.image[i].XF)
	return sx,sy
end

function Animation:setImage(i)
   if self.actImage~=i then
   self.actImage=i
   self.actFrame=1
   end
end

--程序开源，请勿用于商业或不良游戏制作     大夏天2015

