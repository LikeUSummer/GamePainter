-- 游戏主角之一
require("Define")
require("Legend")

EastHero = Legend:New()

function EastHero:New(x, y)
    local obj = {}
    self.wx = x
    self.wy = y

    local image = {}
    image[1] = {}
    image[1].ID = g_assets.HERO_STANDL
    image[1].frameCount = 4
    image[1].frameWidth = 200
    image[2] = {}
    image[2].ID = g_assets.HERO_STANDR
    image[2].frameCount = 4
    image[2].frameWidth = 200
    image[3] = {}
    image[3].ID = g_assets.HERO_RUNL
    image[3].frameCount = 6
    image[3].frameWidth = 200
    image[4] = {}
    image[4].ID = g_assets.HERO_RUNR
    image[4].frameCount = 6
    image[4].frameWidth = 200
    image[5] = {}
    image[5].ID = g_assets.HERO_RUNU
    image[5].frameCount = 6
    image[5].frameWidth = 200
    image[6] = {}
    image[6].ID = g_assets.HERO_RUND
    image[6].frameCount = 6
    image[6].frameWidth = 200
    image[7] = {}
    image[7].ID = g_assets.HERO_RUNUL
    image[7].frameCount = 6
    image[7].frameWidth = 200
    image[8] = {}
    image[8].ID = g_assets.HERO_RUNUR
    image[8].frameCount = 6
    image[8].frameWidth = 200
    image[9] = {}
    image[9].ID = g_assets.HERO_RUNDL
    image[9].frameCount = 6
    image[9].frameWidth = 200
    image[10] = {}
    image[10].ID = g_assets.HERO_RUNDR
    image[10].frameCount = 6
    image[10].frameWidth = 200

    self.animation = Animation:New(image)
    self.animation.dx = 100
    self.animation.dy = 85

    setmetatable(obj, self)
    self.__index = self
    return obj
end
