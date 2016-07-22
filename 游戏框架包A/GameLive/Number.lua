--卡通数字显示类
Number={}

function Number:new(image)
local obj={}
obj.image=image
obj.actImage=1
obj.dx=0
obj.dy=0
setmetatable(obj,self)
self.__index=self
return obj
end

function Number:show(x,y,num)
local i=self.actImage
local sx=0
local n=string.len(num)
for j=1,n do
if num:byte(j)<48 then  
sx=0    --符号
else
sx=(num:byte(j)-47)*self.image[i].FW  --数字
end
Painter.drawImage(self.image[i].ID,x-self.dx+j*self.image[i].FW,y-self.dy,sx,self.image[i].FW)
end
end

function Number:setImage(i)
self.actImage=i
end

require("Res")
local imag={}
imag[1]={}
imag[1].ID=Res.NUM_BLUE
imag[1].FW=24 --每帧宽度
imag[2]={}
imag[2].ID=Res.NUM_RED
imag[2].FW=24 --每帧宽度
number=Number:new(imag)  --全局数字绘制对象
number:setImage(2)