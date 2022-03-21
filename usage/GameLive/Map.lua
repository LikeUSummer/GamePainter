-- 地图基类
require("Define")
require("Painter")

Map = {}
function Map:New(imagePath, x, y, w, h)
    local obj = {}
    obj.ID = -1 -- 对象在世界管理器中的ID
    obj.x = x obj.y = y -- 绘图坐标
    obj.imageID = Painter.AddImage(imagePath)
    obj.width = w
    obj.height = h
    obj.speed = 10
    obj.haveMask = 0 -- 有无遮罩
    obj.maskID = -1 -- 遮罩图ID
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的 __index 为自身，使得派生表可访问自身成员
    return obj
end

function Map:LoadMask(imagePath) -- 添加路径遮罩
    self.maskID = Painter.AddImage(imagePath)
    self.haveMask = 1
end

function Map:Update() -- 更新状态
    self:Change()
    self:Draw()
end

function Map:Draw()
    Painter.DrawImageByScale(self.imageID, self.x, self.y, 1, 1) -- 绘制地景
end

function Map:Change()
    if g_heroX > 2 * WIDTH / 3 then
        if self.width + self.x - self.speed > WIDTH then
            self.x = self.x - self.speed
        else
            self.x = WIDTH - self.width
        end
    elseif g_heroX < WIDTH / 4 then
        if self.x + self.speed < 0 then
            self.x = self.x + self.speed
        else
            self.x = 0
        end
    end

    if g_heroY > 2 * HEIGHT / 3 then
        if self.height + self.y - self.speed > HEIGHT then
            self.y = self.y - self.speed
        else
            self.y = HEIGHT - self.height
        end
    elseif g_heroY < HEIGHT / 4 then
        if self.y + self.speed < 0 then
            self.y = self.y + self.speed
        else
            self.y = 0
        end
    end
    g_mapOffsetX = self.x
    g_mapOffsetY = self.y
end

function Map:OnSize(width, height)
    if self.width + self.x < width then
        self.x = width - self.width
    end
    if self.height + self.y < height then
        self.y = height - self.height
    end
end

function Map:MaskCheck() -- 遮罩检测

end

function Map:OnRButtonDown(x, y)

end

function Map:OnLButtonDown(x, y)

end

function Map:OnLButtonUp(x, y)

end
