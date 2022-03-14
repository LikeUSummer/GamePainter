-- 状态描述类
State = {}

function State:New()
    local obj = {}
    obj.life = 100 -- 生命值
    obj.level = 1 -- 等级
    obj.power = 10 -- 攻击力
    obj.defense = 10 -- 防御力
    obj.attacking = 0 -- 是否处于攻击状态
    obj.range = 50 -- 攻击范围
    obj.frequency = 1 -- 每秒攻击次数

    setmetatable(obj, self)
    self.__index = self
    return obj
end
