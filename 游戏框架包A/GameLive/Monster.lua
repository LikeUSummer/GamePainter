--野怪和敌人的基类
--描述一种来回移动的对象
require("Life")

Monster=Life:new()
function Monster:new()
  local obj={}
  obj.state=State:new()
  obj.timer=-1
  obj.switch_shownumber=0
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function Monster:change() --来回移动
 --[[    if self.timer>0 then
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
      end--]]
      self:onAttacked()
	  self:doTimer()
end

function Monster:doTimer() --定时器处理
     if self.timer>0 then
        self.timer=self.timer-1
    elseif self.timer==0 then
	    self.switch_shownumber=0			   
		self.timer=-1 -- 关闭时钟
    end    
end

function Monster:draw()
       self.animation:show(self.x,self.y)
	   if self.switch_shownumber==1 then
	       number:show(self.x+2,self.y-50,"-"..tostring(MYSTATE.power))
	   end
end

function Monster:onAttacked()
   if MYSTATE.attacking==1 then
       if IN_BOX(MYSTATE.atkX,MYSTATE.atkY,self.x,self.y,80,100)==1 then
         self.state.life=self.state.life-MYSTATE.power
		 self.switch_shownumber=1
		 self.timer=5
		end
   end
end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015