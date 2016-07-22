--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
--[[
这里的Res载入方式是启动一起载入，显然在正式发布游戏时如果资源过多，
这是不合理的方法，所以目前只供测试使用，正式搭建游戏时应该动态地合
理管理资源
--]]
Res={}

Res.MUSIC_SUMMER=Painter.addMusic("GameRes//Sound//summer.mp3")

Res.BACK=Painter.addJPG("GameRes//Image//back.jpg")
Res.SLIDER=Painter.addImage("GameRes//Image//orange.png")
Res.SLIDER_PATH=Painter.addImage("GameRes//Image//slidePath.png")