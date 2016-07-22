FoodSaler=NPC:new() --卖菜人
function FoodSaler:new(x,y)
   local obj={}
    self.wx=x
    self.wy=y
   local image={}
   image[1]={}
   image[1].ID=Res.NPC_FOODSALER
   image[1].F=4--帧数
   image[1].FW=80 --每帧宽度
   self.animation=Animation:new(image)
   self.animation.frameDelay=2
   setmetatable(obj,self)  --新建对象
   self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
   return obj
end

function FoodSaler:near(x,y)  --判断位置是否在角色身上
    if x>self.x and x<self.x+50 then
        if y>self.y and y<self.y+50 then
           return 1
        end
    end
    return 0
end

function FoodSaler:storyBegin()   --故事演绎
     local t=TextBox:new(100,100,"西望夏口，东望武昌，山川相寥，郁乎苍苍")
     local b=Button:new(0,0,btnX,btnY)
     b.onClick=function() world:del(t.ID) end
     t:addChild(b)
     world:add(t)
end

