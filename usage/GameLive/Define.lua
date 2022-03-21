require("State") -- 角色/场景状态

-- 实时鼠标位置
g_mouseX = 0
g_mouseY = 0

-- 实时主角位置
g_heroX = 0
g_heroY = 0

-- 实时地图起点
g_mapOffsetX = 0
g_mapOffsetY = 0

g_heroState = State:New() -- 主角状态

-- 窗口宽高
WIDTH = 1500
HEIGHT = 800

-- 方向常量
NORTH = 1
SOUTH = 2
WEST = 3
EAST = 4
NORTHWEST = 5
NORTHEAST = 6
SOUTHWEST = 7
SOUTHEAST = 8

-- 数学常量
PI = 3.1415927 -- 圆周率
EPI = 0.392699 -- 八分之一 PI
RAD = 0.017453 -- 1 弧度的度数

function IN_BOX(x, y, lx, ly, w, h)
    if x > lx and x < lx + w then
        if y > ly and y < ly + h then
            return 1
        end
    end
    return 0
end

function DRAW_FRAME(id, x, y, frame, w)
    Painter.DrawImageByFrame(id, x, y, w * (frame - 1), w)
end

function DIRECTION(x0, y0, x, y)
    local sita = 0
    if x > x0 and y < y0 then
        sita = math.atan((y0 - y) / (x - x0))
        if sita < EPI then
            return EAST
        end
        if sita > EPI and sita < 3 * EPI then
            return NORTHEAST
        end
        return NORTH
    end

    if x < x0 and y < y0 then
        sita = math.atan((y0 - y) / (x0 - x))
        if sita < EPI then
            return WEST
        end
        if sita > EPI and sita < 3 * EPI then
            return NORTHWEST
        end
        return NORTH
    end

    if x < x0 and y > y0 then
        sita = math.atan((y - y0) / (x0 - x))
        if sita < EPI then
            return WEST
        end
        if sita > EPI and sita < 3 * EPI then
            return SOUTHWEST
        end
        return SOUTH
    end
    if x > x0 and y > y0 then
        sita = math.atan((y - y0) / (x - x0))
        if sita < EPI then
            return EAST
        end
        if sita > EPI and sita < 3 * EPI then
            return SOUTHEAST
        end
        return SOUTH
    end
end
