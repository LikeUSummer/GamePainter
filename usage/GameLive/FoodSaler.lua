-- 商人
require("Animation")
require("Button")
require("NPC")
require("TextBox")

FoodSaler = NPC:New()
function FoodSaler:New(x, y)
    local obj = {}
    self.wx = x
    self.wy = y
    local image = {}
    image[1] = {}
    image[1].ID = g_assets.NPC_FOODSALER
    image[1].frameCount = 4 -- 帧数
    image[1].frameWidth = 80 -- 每帧宽度
    self.animation = Animation:New(image)
    self.animation.frameRepeat = 2
    setmetatable(obj, self) -- 新建对象
    self.__index = self -- 设置基类(元表)的__index为自身，使得派生表可访问自身成员
    return obj
end

function FoodSaler:Near(x, y) -- 判断位置是否在角色身上
    if x > self.x and x < self.x + 50 then
        if y > self.y and y < self.y + 50 then
            return 1
        end
    end
    return 0
end

function FoodSaler:Story() -- 故事演绎
    local textBox = TextBox:New(100, 100, "大丈夫当朝碧海而暮苍梧", 0xFF4A4137)
    local button = Button:New(0, 0, 302, 190)
    button.OnClick = function()
        world:Delete(textBox.ID)
    end
    textBox:AddChild(button)
    world:Add(textBox)
end
