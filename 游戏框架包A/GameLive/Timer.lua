--[[
这个模块希望实现这样一种机制：
游戏程序许多地方需要定时功能，如按攻击键后角色需要在何时停止攻击，炮弹在射出后多久无效并销毁，NPC隔多长时间自言自语一下等；
以前我的做法是把这些程序也零碎地写进一些消息响应函数中，如onChange，onKeyDown里面，这样混在其中的确显得不干净简洁；所以
稍微总结一下共性后，便想写一个计时器模块，用它来统一管理那些和定时有关的程序段
--]]

Timer={}

function Timer:new()  
    local obj={}
	obj.timerList={}   --定时器表
	obj.id=0
    setmetatable(obj,self)
	self.__index=self
	return obj
end	

function Timer:add(func,dt,rpt) --依次是定时程序，触发间隔，重复次数
    self.id=self.id+1
	local i=self.id
	self.timerList[i]={}
    self.timerList[i].process=func
	self.timerList[i].dt=dt
	self.timerList[i].rpt=rpt
	self.timerList[i].tm=0    --计时
	self.timerList[i].cnt=0	--计次
	self.timerList[i].on=0    --开关
end

function  Timer:doTimer()
   for k,v in pairs(self.timerList) do
       if  v.on==1 then
	      if  v.cnt>=v.rpt and v.rpt~=-1 then
		       v.on=0
	       elseif v.dt==v.tm  then --间隔触发
		       v.process()
		       v.tm=0
		       v.cnt=v.cnt+1
		    else
		        v.tm=v.tm+1
		    end
		end
   end
end

function  Timer:enable(i)
	self.timerList[i].on=1    --打开i号计时器
	self.timerList[i].cnt=0
	self.timerList[i].tm=0	
end

function  Timer:disable(i)
	self.timerList[i].on=0    --关闭i号计时器
end


--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015