 --野怪阿木木
 require("Monster")
MuMu=Monster:new()
function MuMu:new(x,y)
  local obj={}
   self.speed=5  --公共属性
   obj.wx=x
   obj.wy=y
   local image={}
   image[1]={}
   image[1].ID=Res.MON_MUMUL
   image[1].XF=8 --帧数
   image[1].YF=1
   image[1].FW=80 --每帧宽度
   image[1].FH=100
   image[1].dx=47
   image[1].dy=91
   image[2]={}
   image[2].ID=Res.MON_MUMUR
   image[2].XF=8 --帧数
   image[2].YF=1
   image[2].FW=80 --每帧宽度
   image[2].FH=100
   image[2].dx=31
   image[2].dy=93
   obj.animation=Animation:new(image)
   obj.animation.frameDelay=3
   setmetatable(obj,self)  --新建对象
   self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015

