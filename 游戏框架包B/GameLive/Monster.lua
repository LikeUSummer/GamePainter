--野怪和敌人的基类
--描述一种来回移动的对象
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
Monster=Life:new()
function Monster:new()
  local obj={}
  obj.state=State:new()
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function Monster:change() --来回移动
      if self.timer>0 then
         self.timer=self.timer-1
         if self.direction==EAST then
            self.wx=self.wx+self.speed
         else
            self.wx=self.wx-self.speed
         end
      else
         self.timer=16
         if self.direction==EAST then
           self.direction=WEST
           self.animation:setImage(1)
         else
            self.direction=EAST
            self.animation:setImage(2)
         end
      end

      self:onAttacked()
end

function Monster:draw()
       self.animation:show(self.x,self.y)
       Painter.drawText(self.x+30,self.y-20,"生命值"..tostring(self.state.life))
end

function Monster:onAttacked()
   if MYSTATE.attacking==1 then
      self.state.life=self.state.life-MYSTATE.power
   end
end


