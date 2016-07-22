--野怪北极熊
Bear=Monster:new()
function Bear:new(x,y)
  local obj={}
   self.wx=x
   self.wy=y
   local image={}
   image[1]={}
   image[1].ID=Res.MON_BEARL
   image[1].F=8 --帧数
   image[1].FW=81 --每帧宽度
   image[1].dx=42
   image[1].dy=99  
   image[2]={}
   image[2].ID=Res.MON_BEARR
   image[2].F=8 --帧数
   image[2].FW=81 --每帧宽度
   image[1].dx=37
   image[1].dy=99
   self.animation=Animation:new(image)
   self.animation.frameDelay=2  --帧重复次数
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function Bear:onLDown(x,y)
    if IN_BOX(x,y,self.x,self.y,80,80)==1 then
        local t=TextBox:new(self.x-200,self.y-120,"可乐的味道真不错啊")
        t.imgID=Res.BOX_SAY
        t.lock=1
        t.width=244
        t.height=113
        t.textX=19
        t.textY=21
        world:add(t)
    end
end

--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
