-- 按钮基类
require("Define")
require("UI")

Button = UI:New()

function Button:New(x, y, rx, ry)
    local obj = {}
    obj.x = x -- 绘图坐标
    obj.y = y
    obj.rx = rx -- 偏移坐标（用于子控件）
    obj.ry = ry
    obj.frame = 1
    obj.OnClick = {} -- 回调函数
    obj.imageID = g_assets.BTN_CHECK
    obj.width = 45
    obj.height = 24
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Button:OnLButtonDown(x, y)
    if IN_BOX(x, y, self.x, self.y, self.width, self.height) == 1 then
        self.frame = 2
        self.mDown = 1
    end
end

function Button:OnLButtonUp(x, y)
    self.mDown = 0
    self.frame = 1
    if IN_BOX(x, y, self.x, self.y, self.width, self.height) == 1 then
        self:OnClick()
    end
end

function Button:Update()
    self:Change()
    self:Draw()
end
