 --野怪阿木木
 --程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
MuMu=Monster:new()
function MuMu:new(x,y)
  local obj={}
   self.speed=5
   self.wx=x
   self.wy=y
   local image={}
   image[1]={}
   image[1].ID=Res.MON_MUMUL
   image[1].F=8 --帧数
   image[1].FW=80 --每帧宽度
   image[2]={}
   image[2].ID=Res.MON_MUMUR
   image[2].F=8 --帧数
   image[2].FW=80 --每帧宽度
   self.animation=Animation:new(image)
   self.animation.frameDelay=3
   setmetatable(obj,self)  --新建对象
   self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

