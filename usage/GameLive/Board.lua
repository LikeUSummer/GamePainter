-- 固定面板控件
require("Define")
require("UI")

Board = UI:New()

function Board:New(x, y)
    local obj = {}
    self.x = x
    self.y = y
    obj.image = {}
    obj.imageID = g_assets.BRD_TOOL
    obj.width = 800
    obj.height = 205
    obj.child = {} -- 子控件集
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Board:Change() -- 状态改变
    for k, v in pairs(self.child) do
        v:Change()
    end
    self.x = (WIDTH - self.width) / 2
    self.y = HEIGHT - self.height;
end
