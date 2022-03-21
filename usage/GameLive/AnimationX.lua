-- 动画基类
--[[
    参数结构约定：
    传入的image为图片信息表，每一个图片元素用 {ID, frame, frameWidth} 组表示
    其中 frame 是图片帧数，frameWidth 是每帧宽度
    用缩写变量是为了尽可能便于书写，否则语句会冗长
--]]
Animation = {}

function Animation:New(imageList) -- 传入图像ID表
    local obj = {}
    obj.imageList = imageList
    obj.lock = 0
    obj.imageIndex = 1 -- 当前图像索引
    obj.frame = 1 -- 当前帧
    obj.frameRepeat = 1 -- 每帧重复次数，可控制帧率
    obj.frameRepeatCounter = 1 -- 当前帧已画次数
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Animation:LockFrame(frame)
    self.lock = 1
    self.frame = frame
end

function Animation:Show(x, y)
    local index = self.imageIndex
    local sx, sy = self:GetFrame(self.frame)
    Painter.DrawImage(self.imageList[index].ID, x - self.imageList[index].dx, y - self.imageList[index].dy, sx, sy, self.imageList[index].frameWidth,
        self.imageList[index].frameHeight)
    if self.lock == 0 then
        if self.frameRepeatCounter < self.frameRepeat then
            self.frameRepeatCounter = self.frameRepeatCounter + 1
        else
            if self.frame == self.imageList[index].frameCount * self.imageList[index].YF then
                self.frame = 1
            else
                self.frame = self.frame + 1
            end
            self.frameRepeatCounter = 1
        end
    end
end

function Animation:GetFrame(frame)
    local index = self.imageIndex
    local sx = self.imageList[index].frameWidth * math.floor((frame - 1) %
        self.imageList[index].frameCount)
    local sy = self.imageList[index].frameHeight * math.floor((frame - 1) /
        self.imageList[index].frameCount)
    return sx, sy
end

function Animation:SetImage(index)
    if self.imageIndex ~= index then
        self.imageIndex = index
        self.frame = 1
    end
end

-- 程序开源，请勿用于商业或不良游戏制作     大夏天2015

