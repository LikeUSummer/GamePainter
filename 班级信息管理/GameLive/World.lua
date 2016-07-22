--运行时对象容器，世界管理器

World={}

function World:new()
   local obj={}
   obj.Active={}--活动对象池
   obj.focus=nil --当前焦点对象
   obj.nID=0   --当前ID
   setmetatable(obj,self)
   self.__index=self
   return obj
end

function World:add(obj)
   self.nID=self.nID+1
   self.Active[self.nID]=obj
end

--通过对象指针删除对象
function World:del(obj)
	 for k,v in pairs(self.Active) do
	    if v==obj then
           table.remove(self.Active,k)
		   self.nID=self.nID-1
		end
	 end
end

function World:release()
   for i=1,self.nID do
      self.Active:remove(i)
   end
end

 world=World:new() --创建全局世界管理器对象

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015
