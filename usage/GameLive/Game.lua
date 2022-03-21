-- 游戏前端核心脚本
package.path = package.path .. ";GameLive/?.lua;"
require("Painter") -- GamePainter传递的C函数库
require("Define") -- 全局常量/变量
require("World") -- 世界管理器

require("EastHero") -- 主角基类
require("FoodSaler") -- 商人
require("Bear") -- 野怪北极熊
require("Mumu") -- 野怪阿木木
require("Map") -- 地图
require("Board") -- 状态面板

function GameInit()
    require("Assets")
    Painter.SetClock(100)
    Painter.SetCanvas(WIDTH, HEIGHT)
    Painter.SetFont("宋体", 12)

    -- 创建世界元素
    map = Map:New("GameRes/Image/长安城b.jpg", -349, -1225, 3800, 2438)
    world = World:New()
    world:Add(map)
    world:Add(Bear:New(904, 1089))
    world:Add(MuMu:New(126, 2137))
    world:Add(FoodSaler:New(803, 1637))
    MY_ID = world:Add(EastHero:New(971, 1728))
    world:Add(Board:New(200,395))
    -- Painter.PlayMedia(g_assets.MUSIC_SUMMER);--背景音乐
end

function GameLoop() -- 游戏主循环函数，必须含有
    -- Painter.DrawImageByScale(imageID, 0, 0, 1, 1)
    -- Painter.DrawSolidRect(0, 0, WIDTH, HEIGHT, 0xFF666666)
    -- local text = "你好，世界"
    -- Painter.DrawString(0, 0, text .. utf8.len(text), 0xFFFFFFFF)
    for k, obj in pairs(world.noumena) do
        obj:Update()
    end
    g_heroState.attacking = 0
    Painter.UpdateCanvas()
end

function OnLButtonDown(x, y) -- 鼠标左键按下
    for k, obj in pairs(world.noumena) do
        if obj.OnLButtonDown then
            obj:OnLButtonDown(x, y)
        end
    end
end

function OnLButtonUp(x, y) -- 鼠标左键松开
    for k, obj in pairs(world.noumena) do
        if obj.OnLButtonUp then
            obj:OnLButtonUp(x, y)
        end
    end
end

function OnMouseMove(x, y) -- 鼠标移动
    g_mouseX = x
    g_mouseY = y
end

function OnRButtonDown(x, y) -- 鼠标右键按下
    for k, obj in pairs(world.noumena) do
        if obj.OnRButtonDown then
            obj:OnRButtonDown(x, y)
        end
    end
end

function OnLButtonClick(x, y) -- 鼠标左键双击

end

function OnMouseWheel(x, y, nDelta) -- 鼠标轮滚动

end

function OnVKeyDown(nKey, nRep) -- 虚拟键按下

end

function OnCKeyDown(nKey, nRep) -- 字符键按下

end

function OnSize(width, height) -- 窗口尺寸变化
    WIDTH = width
    HEIGHT = height
    map:OnSize(width, height)
end
