-- 所有活动元素的基类
Life = {}
function Life:New()
    local obj = {}
    obj.ID = 0 -- 对象在世界管理器中的ID
    obj.x = 0
    obj.y = 0
    obj.wx = 0
    obj.wy = 0
    obj.animation = {} -- 对象的动画管理器
    obj.direction = WEST -- 朝向
    obj.timer = 16 -- 计数器
    obj.life = 100 -- 生命值
    obj.speed = 0 -- 移动速度
    obj.changed = 0 -- 状态改变标志
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function Life:Update() -- 对外界更新，成员函数
    self:Transform()
    self:Change()
    self:Draw()
end

function Life:Draw()
    self.animation:Show(self.x, self.y)
end

function Life:Change() -- 状态更新，由具体角色实现

end

function Life:Transform() -- 坐标变换（对象依赖于地图,self.x是绘图坐标，self.wx是世界坐标）
    self.x = self.wx + g_mapOffsetX
    self.y = self.wy + g_mapOffsetY
end
function Life:OnLButtonDown(x, y)

end

function Life:OnRButtonDown(x, y)

end

function Life:OnLButtonUp(x, y)

end

