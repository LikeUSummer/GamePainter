-- 界面交互控件的基类
require("Define")
require("Painter")

UI = {}
function UI:New()
    local obj = {}
    obj.ID = -1 -- 对象在世界管理器中的ID
    obj.mDown = 0 -- 鼠标左键是否按下
    obj.imageID = -1
    obj.width = 0
    obj.height = 0
    obj.frame = 1 -- 当前帧
    obj.enable = 1 -- 控件是否可用
    obj.child = {} -- 子控件(派生类必须重新定义，否则将共用此表，也就是表结构无法继承复制)
    obj.nChild = 0 -- 子控件数量
    obj.mx = 0
    obj.my = 0
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function UI:Update() -- 对外界更新，成员函数
    if self.enable == 1 then
        self:Change()
        self:Draw()
    end
end

function UI:Draw()
    Painter.DrawImageByFrame(self.imageID, self.x, self.y, (self.frame - 1) * self.width, self.width)
end

function UI:Change()

end

function UI:OnLButtonDown(x, y)
    for k, v in pairs(self.child) do
        v:OnLButtonDown(x, y)
    end
    if IN_BOX(g_mouseX, g_mouseY, self.x, self.y, self.width, self.height) then
        self.mDown = 1
    end
end

function UI:OnLButtonUp(x, y)
    for k, v in pairs(self.child) do
        v:OnLButtonUp(x, y)
    end
    self.mDown = 0
end

function UI:OnRButtonDown(x, y)
    for k, v in pairs(self.child) do
        v:OnRButtonDown(x, y)
    end
end

function UI:AddChild(obj)
    self.nChild = self.nChild + 1
    self.child[self.nChild] = obj
end
