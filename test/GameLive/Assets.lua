--[[
这里的Res载入方式是启动一起载入，显然在正式发布游戏时如果资源过多，
这是不合理的方法，所以目前只供测试使用，正式搭建游戏时应该动态地合
理管理资源
--]]

g_assets = {}
g_assets.HERO_RUNL = Painter.AddImage("GameRes/Image/heroL.png")
g_assets.HERO_RUNR = Painter.AddImage("GameRes/Image/heroR.png")
g_assets.HERO_RUNU = Painter.AddImage("GameRes/Image/heroRU.png")
g_assets.HERO_RUND = Painter.AddImage("GameRes/Image/heroRD.png")
g_assets.HERO_RUNUL = Painter.AddImage("GameRes/Image/heroRUL.png")
g_assets.HERO_RUNUR = Painter.AddImage("GameRes/Image/heroRUR.png")
g_assets.HERO_RUNDL = Painter.AddImage("GameRes/Image/heroRDL.png")
g_assets.HERO_RUNDR = Painter.AddImage("GameRes/Image/heroRDR.png")
g_assets.HERO_STANDL = Painter.AddImage("GameRes/Image/heroLS.png")
g_assets.HERO_STANDR = Painter.AddImage("GameRes/Image/heroRS.png")

g_assets.BTN_CHECK = Painter.AddImage("GameRes/Image/button1.png")
g_assets.BOX_TEXT = Painter.AddImage("GameRes/Image/Box1.png")
g_assets.BRD_TOOL = Painter.AddImage("GameRes/Image/ToolBoard.png")
g_assets.BOX_SAY = Painter.AddImage("GameRes/Image/Saying.png")

g_assets.NPC_FOODSALER = Painter.AddImage("GameRes/Image/FoodSaler.png")

g_assets.MON_BEARL = Painter.AddImage("GameRes/Image/BearL.png")
g_assets.MON_BEARR = Painter.AddImage("GameRes/Image/BearR.png")

g_assets.MON_MUMUL = Painter.AddImage("GameRes/Image/MumuL.png")
g_assets.MON_MUMUR = Painter.AddImage("GameRes/Image/MumuR.png")

g_assets.MUSIC_SUMMER = Painter.AddMedia("GameRes/Sound/summer.mp3")
