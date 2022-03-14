-- 运行时对象容器，世界管理器
World = {}

function World:New()
    local obj = {}
    obj.noumena = {} -- 世界中的实体集合
    obj.maxID = 0
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function World:Add(obj)
    self.maxID = self.maxID + 1
    table.insert(self.noumena, self.maxID, obj)
    obj.ID = self.maxID
    return obj.ID -- 有些时候外界需要知道对象ID
end

function World:Delete(id)
    table.remove(self.noumena, id)
    self.maxID = self.maxID - 1
end

function World:Clear()
    for index = 1, self.maxID do
        self.noumena:remove(index) -- 等待垃圾回收处理
    end
end
