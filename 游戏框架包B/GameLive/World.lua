--运行时对象容器，世界管理器
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
World={}

function World:new()
   local obj={}
   obj.Active={}--活动对象池
   obj.nID=0   --当前ID
   setmetatable(obj,self)
   self.__index=self
   return obj
end

function World:add(obj)
   self.nID=self.nID+1
   table.insert(self.Active,self.nID,obj)
   obj.ID=self.nID
   return obj.ID  --有些时候外界需要知道对象ID
end

function World:del(id)
     table.remove(self.Active,id)
     self.nID=self.nID-1
end

function World:release()
   for i=1,self.nID do
      self.Active:remove(i) --等待垃圾回收处理
   end
end

 world=World:new() --创建实例
