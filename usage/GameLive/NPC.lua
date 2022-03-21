require("Life")

NPC = Life:New() -- 其他角色的基类

function NPC:New()
    local obj = {}
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function NPC:OnRButtonDown(x, y)
    if self:Near(x, y) == 1 then
        slef:Story()
    end
end

function NPC:OnLButtonDown(x, y) -- NPC响应左键单击
    if self:Near(x, y) == 1 then
        self:Story()
    end
end

function NPC:Change() -- 状态改变

end
