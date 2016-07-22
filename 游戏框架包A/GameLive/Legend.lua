--游戏主角的基类，这个类完成对鼠标右键等操作的处理
require("Life")
require("Timer")

Legend=Life:new() --每一个角色，都是一个传奇
function Legend:new()
  local obj={}
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function Legend:onRDown(x,y) --响应右键单击
    self.mx=x-WX --记下按下鼠标时的世界位置
    self.my=y-WY
    self.direction=DIRECTION(self.x,self.y,x,y)
    if self.direction==EAST then
      self.animation:setImage(2)
    elseif self.direction==WEST then
      self.animation:setImage(4)
    end
    self.walking=1
	self.timer:enable(2)  --打开1号时钟
	self.timer:enable(1)  --打开2号时钟
end

--闭包时钟函数(采用闭包是方便外部访问self参数)
function Legend:timer1() --切换为静止态
	return function()  
	    self.animation:setImage(1)    
	end
end

function Legend:timer2() --行走
	return function()  
	    if self.animation.actImage==2 or self.animation.actImage==4 then  
	      self:findRoute()
        end		  
	end
end

function  Legend:timer3()
	return function()
	     MYSTATE.attacking=0
		 self.animation:setImage(1)
	end
end

function Legend:change() --状态改变
    HX=self.x  --反馈主角屏幕位置给全局
    HY=self.y 
	self.timer:doTimer()
end

function Legend:findRoute()  --寻路行走
    if self.direction==EAST then
     self.wx=self.wx+self.speed
    elseif self.direction==WEST then
     self.wx=self.wx-self.speed
     elseif self.direction==NORTH then
     self.wy=self.wy-self.speed/2
     elseif self.direction==SOUTH then
     self.wy=self.wy+self.speed/2
    end
end

function Legend:onCKeyDown(nKey,nRep) --字符键按下
   if nKey==65 then   --按下A键
        MYSTATE.atkX=self.x+142   --更新攻击域位置
		MYSTATE.atkY=self.y+77 
		MYSTATE.attacking=1
        self.animation:setImage(3)
		self.timer:enable(3)
    end
end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015
