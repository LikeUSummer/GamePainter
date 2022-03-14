-- 野怪北极熊
require("Animation")
require("Define")
require("Monster")
require("TextBox")

Bear = Monster:New()
function Bear:New(x, y)
    local obj = {}
    self.wx = x
    self.wy = y
    local image = {}
    image[1] = {}
    image[1].ID = g_assets.MON_BEARL
    image[1].frameCount = 8 -- 帧数
    image[1].frameWidth = 81 -- 每帧宽度
    image[2] = {}
    image[2].ID = g_assets.MON_BEARR
    image[2].frameCount = 8 -- 帧数
    image[2].frameWidth = 81 -- 每帧宽度
    self.animation = Animation:New(image)
    self.animation.frameRepeat = 2 -- 帧重复次数
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function Bear:OnLButtonDown(x, y)
    if IN_BOX(x, y, self.x, self.y, 80, 80) == 1 then
        local t = TextBox:New(self.x - 200, self.y - 120, "可乐的味道真不错啊", 0xFFFFFFFF)
        t.imageID = g_assets.BOX_SAY
        t.lock = 1
        t.width = 244
        t.height = 113
        t.textX = 19
        t.textY = 21
        world:Add(t)
    end
end
