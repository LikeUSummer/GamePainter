require("NPC")
FoodSaler=NPC:new() --食品商人
function FoodSaler:new(x,y)
    local obj={}
    obj.wx=x
    obj.wy=y
	obj.x=0
	obj.y=0
	obj.width=23
	obj.height=67
	local image={}
    image={}
    image[1]={}
    image[1].ID=Res.NPC_FOODSALER
    image[1].XF=4--帧数
    image[1].YF=1
    image[1].FW=80 --每帧宽度
    image[1].FH=80
    image[1].dx=28
    image[1].dy=73
    obj.animation=Animation:new(image)
    obj.animation.frameDelay=2
    setmetatable(obj,self)
    self.__index=self  
    return obj
end

function FoodSaler:near(x,y)  --判断位置是否在角色身上
    if x>self.x-self.width/2 and x<self.x+self.width/2 then
        if y>self.y-self.height and y<self.y then
           return 1
        end
    end
    return 0
end

function FoodSaler:storyBegin()   --故事演绎
     local t=TextBox:new(100,100,"西望夏口，东望武昌，山川相寥，郁乎苍苍")
     local b=Button:new(0,0,btnX,btnY)
     b.onClick=function() world:del(t) end
     t:addChild(b)
     world:add(t)
end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015
