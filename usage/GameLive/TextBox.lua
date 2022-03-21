require("UI")
require("Define")

TextBox = UI:New() -- 文本框类
function TextBox:New(x, y, text, textColor)
    local obj = {}
    obj.x = x
    obj.y = y
    obj.wx = x - g_mapOffsetX
    obj.wy = y - g_mapOffsetY
    obj.textX = 55
    obj.textY = 69
    obj.lineChars = 16 -- 每行字符数
    obj.text = text
    obj.textColor = textColor
    obj.len = string.len(text) / 2 -- 中文
    obj.lock = 0 -- 是否固定
    obj.mx = 0 -- 鼠标左键按下的位置
    obj.my = 0
    obj.ox = 0 -- 鼠标左键按下时控件位置
    obj.oy = 0
    obj.child = {} -- 子控件表
    obj.imageID = g_assets.BOX_TEXT -- 默认对话框背景
    obj.width = 380
    obj.height = 240
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function TextBox:Draw()
    local index = 1 -- 字索引
    local row = 0 -- 行数
    if self.lock == 1 then
        self.x = self.wx + g_mapOffsetX
        self.y = self.wy + g_mapOffsetY
    end
    Painter.DrawImageByScale(self.imageID, self.x, self.y, 1, 1)
    charHeight = 12
    while index < self.len do
        if index + self.lineChars < self.len then
            Painter.DrawString(self.x + self.textX, row * charHeight + self.y + self.textY,
                -- utf8:sub(self.text, index, index + self.lineChars), -- 目前有问题，待修复
                self.text, self.textColor)
            row = row + 1 -- 换行
        else
            Painter.DrawString(self.x + self.textX, row * charHeight + self.y + self.textY,
                -- utf8:sub(self.text, index, self.len), -- 目前有问题，待修复
                self.text, self.textColor)
        end
        index = index + self.lineChars
    end
    for k, v in pairs(self.child) do
        v.x = self.x + v.rx
        v.y = self.y + v.ry
        v:Draw()
    end
end

function TextBox:OnLButtonDown(x, y)
    for k, v in pairs(self.child) do
        v:OnLButtonDown(x, y)
    end
    if IN_BOX(g_mouseX, g_mouseY, self.x, self.y, self.width, self.height) == 1 then
        self.mDown = 1
        self.mx = x
        self.my = y
        self.ox = self.x
        self.oy = self.y
    end
end

function TextBox:Change() -- 状态改变
    for k, v in pairs(self.child) do
        v:Change()
    end
    if self.mDown == 1 then
        self.x = self.ox + g_mouseX - self.mx
        self.y = self.oy + g_mouseY - self.my
    end
end
