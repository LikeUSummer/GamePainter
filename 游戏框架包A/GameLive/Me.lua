--游戏主角之一
require("Legend")
Me=Legend:new()

function Me:new(x,y)
  local obj={}
   setmetatable(obj,self)  --新建对象
   self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
   
  obj.wx=x
  obj.wy=y
  obj.x=0  --会自动更新
  obj.y=0
  obj.width=55
  obj.height=96
  obj.mx=0
  obj.my=0
  obj.walking=0
  obj.attacking=0
  obj.timer=-1
  obj.speed=10
  obj.direction=EAST
  
   local image={}
   image[1]={}
   image[1].ID=Res.ZHANR
   image[1].XF=4     --横向帧数
   image[1].YF=2     --纵向帧数
   image[1].FW=230 --每帧宽高
   image[1].FH=160
   image[1].dx=109  --基准点偏移
   image[1].dy=152  
  
   image[2]={}
   image[2].ID=Res.PAOR
   image[2].XF=4
   image[2].YF=1
   image[2].FW=230 
   image[2].FH=107
   image[2].dx=108
   image[2].dy=104  

   --[[ 骑士奔腾
   image[2]={}
   image[2].ID=Res.QISHI_PAOR
   image[2].XF=4
   image[2].YF=2
   image[2].FW=352
   image[2].FH=260
   image[2].dx=156
   image[2].dy=250
--]]
   
   image[3]={}
   image[3].ID=Res.GONGR
   image[3].XF=4
   image[3].YF=2
   image[3].FW=230
   image[3].FH=160
   image[3].dx=108
   image[3].dy=152
   
   image[4]={}
   image[4].ID=Res.PAOL
   image[4].XF=4
   image[4].YF=1
   image[4].FW=230
   image[4].FH=107
   image[4].dx=121
   image[4].dy=104
   obj.animation=Animation:new(image)
  
   obj.timer=Timer:new()
   obj.timer:add(obj:timer1(),8,1)
   obj.timer:add(obj:timer2(),0,8)   
   obj.timer:add(obj:timer3(),8,1)
  return obj
end

--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015

