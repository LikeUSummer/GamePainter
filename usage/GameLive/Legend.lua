-- 游戏主角的基类，这个类只完成对鼠标右键的处理
require("Life")

Legend = Life:New() -- 每一个角主角，都是一个传奇
function Legend:New()
    local obj = {}
    obj.mx = 0
    obj.my = 0
    self.timer = 0
    self.speed = 10
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function Legend:OnRButtonDown(x, y) -- 响应右键单击
    self.mx = x - g_mapOffsetX -- 记下按下鼠标时的世界位置
    self.my = y - g_mapOffsetY
    self.changed = 1
    self.direction = DIRECTION(self.x, self.y, x, y)

    -- 根据当前方向选择动画
    if self.direction == EAST then
        self.animation:SetImage(4)
    elseif self.direction == NORTH then
        self.animation:SetImage(5)
    elseif self.direction == WEST then
        self.animation:SetImage(3)
    elseif self.direction == SOUTH then
        self.animation:SetImage(6)
    elseif self.direction == NORTHEAST then
        self.animation:SetImage(8)
    elseif self.direction == NORTHWEST then
        self.animation:SetImage(7)
    elseif self.direction == SOUTHEAST then
        self.animation:SetImage(10)
    elseif self.direction == SOUTHWEST then
        self.animation:SetImage(9)
    end
    self.timer = 8;
end

function Legend:Change() -- 状态改变
    g_heroX = self.x -- 反馈主角屏幕位置给全局
    g_heroY = self.y
    if self.timer > 0 then
        self:FindRoute()
        self.timer = self.timer - 1
    else
        if self.direction == EAST then -- 已到达
            self.animation:SetImage(2)
        else
            self.animation:SetImage(1)
        end
        self.changed = 0
    end
end

function Legend:FindRoute() -- 寻路行走（仅供测试效果，有待优化改进）
    local dv = self.speed * 0.8
    if self.direction == EAST then
        self.wx = self.wx + self.speed
    elseif self.direction == NORTH then
        self.wy = self.wy - self.speed
    elseif self.direction == WEST then
        self.wx = self.wx - self.speed
    elseif self.direction == SOUTH then
        self.wy = self.wy + self.speed
    elseif self.direction == NORTHEAST then
        self.wx = self.wx + dv
        self.wy = self.wy - dv
    elseif self.direction == NORTHWEST then
        self.wx = self.wx - dv
        self.wy = self.wy - dv
    elseif self.direction == SOUTHEAST then
        self.wx = self.wx + dv
        self.wy = self.wy + dv
    elseif self.direction == SOUTHWEST then
        self.wx = self.wx - dv
        self.wy = self.wy + dv
    end
end

function Legend:onCKeyDown(nKey, nRep)

end

-- 程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
