-- 野怪和敌人的基类，描述一种来回移动的对象
require("Life")

Monster = Life:New()
function Monster:New()
    local obj = {}
    obj.state = State:New()
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function Monster:Change() -- 来回移动
    if self.timer > 0 then
        self.timer = self.timer - 1
        if self.direction == EAST then
            self.wx = self.wx + self.speed
        else
            self.wx = self.wx - self.speed
        end
    else
        self.timer = 16
        if self.direction == EAST then
            self.direction = WEST
            self.animation:SetImage(1)
        else
            self.direction = EAST
            self.animation:SetImage(2)
        end
    end

    self:OnAttacked()
end

function Monster:Draw()
    self.animation:Show(self.x, self.y)
    Painter.DrawString(self.x + 30, self.y - 20, "生命值" .. tostring(self.state.life), 0xFFAA5522)
end

function Monster:OnAttacked()
    if g_heroState.attacking == 1 then
        self.state.life = self.state.life - g_heroState.power
    end
end

