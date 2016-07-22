--固定面板控件
Board=UI:new()

function Board:new(x,y)
    local obj={}
	obj.x=x
	obj.y=y
	obj.image={}
	obj.imgID=Res.BRD_TOOL
	obj.width=800
	obj.height=205
	obj.child={} --子控件集
	setmetatable(obj,self)
	self.__index=self
	return obj
end
