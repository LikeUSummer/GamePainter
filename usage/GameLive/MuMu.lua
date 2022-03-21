-- 野怪阿木木
require("Animation")
require("Monster")

MuMu = Monster:New()
function MuMu:New(x, y)
    local obj = {}
    self.speed = 5
    self.wx = x
    self.wy = y
    local image = {}
    image[1] = {}
    image[1].ID = g_assets.MON_MUMUL
    image[1].frameCount = 8 -- 帧数
    image[1].frameWidth = 80 -- 每帧宽度
    image[2] = {}
    image[2].ID = g_assets.MON_MUMUR
    image[2].frameCount = 8 -- 帧数
    image[2].frameWidth = 80 -- 每帧宽度
    self.animation = Animation:New(image)
    self.animation.frameRepeat = 3
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end
