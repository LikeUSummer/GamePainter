--游戏主角之一
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
Me=Legend:new()

function Me:new(x,y)
  local obj={}
  self.wx=x
  self.wy=y
   local image={}
   image[1]={}
   image[1].ID=Res.HERO_STANDL
   image[1].F=4 --帧数
   image[1].FW=200 --每帧宽度
   image[2]={}
   image[2].ID=Res.HERO_STANDR
   image[2].F=4 --帧数
   image[2].FW=200 --每帧宽度
   image[3]={}
   image[3].ID=Res.HERO_RUNL
   image[3].F=6 --帧数
   image[3].FW=200 --每帧宽度
   image[4]={}
   image[4].ID=Res.HERO_RUNR
   image[4].F=6--帧数
   image[4].FW=200 --每帧宽度
   image[5]={}
   image[5].ID=Res.HERO_RUNU
   image[5].F=6--帧数
   image[5].FW=200 --每帧宽度
   image[6]={}
   image[6].ID=Res.HERO_RUND
   image[6].F=6--帧数
   image[6].FW=200 --每帧宽度
   image[7]={}
   image[7].ID=Res.HERO_RUNUL
   image[7].F=6 --帧数
   image[7].FW=200 --每帧宽度
   image[8]={}
   image[8].ID=Res.HERO_RUNUR
   image[8].F=6--帧数
   image[8].FW=200 --每帧宽度
   image[9]={}
   image[9].ID=Res.HERO_RUNDL
   image[9].F=6--帧数
   image[9].FW=200 --每帧宽度
   image[10]={}
   image[10].ID=Res.HERO_RUNDR
   image[10].F=6--帧数
   image[10].FW=200 --每帧宽度
   self.animation=Animation:new(image)
   self.animation.dx=100
   self.animation.dy=85
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

