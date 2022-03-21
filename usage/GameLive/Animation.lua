-- 动画基类
--[[
    参数结构约定：
    传入的image为图片信息表，每一个图片元素用 {ID, frame, frameWidth} 组表示
    其中 frame 是图片帧数，FW 是每帧宽度
    之所以用缩写变量是为了尽可能便于书写，否则语句会冗长
--]]

Animation = {}
function Animation:New(imageList) -- 传入图像ID表
    local obj = {}
    obj.imageList = imageList
    obj.lock = 0
    obj.dx = 0 -- 偏移量（用于矫正角色计算点）
    obj.dy = 0
    obj.imageIndex = 1 -- 当前图像索引
    obj.frame = 1 -- 当前帧
    obj.frameRepeat = 1 -- 每帧重复次数，可控制动画速率
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
    local sx = (self.frame - 1) * self.imageList[index].frameWidth
    Painter.DrawImageByFrame(
        self.imageList[index].ID,
        x - self.dx, y - self.dy,
        sx, self.imageList[index].frameWidth
    )
    if self.lock == 0 then
        if self.frameRepeatCounter < self.frameRepeat then
            self.frameRepeatCounter = self.frameRepeatCounter + 1
        else
            if self.frame == self.imageList[index].frameCount then
                self.frame = 1
            else
                self.frame = self.frame + 1
            end
            self.frameRepeatCounter = 1
        end
    end
end

function Animation:SetImage(index)
    if self.imageIndex ~= index then
        self.imageIndex = index
        self.frame = 1
    end
end
