require("UI")
SlideBar=UI:new()

function SlideBar:new(x,y)
  local obj={}
  obj.x=x
  obj.y=y
  obj.pathX=x+5
  obj.pathY=0

  obj.mx=0  --鼠标左键按下的位置
  obj.my=0
  obj.ox=0   --鼠标左键按下时控件位置
  obj.oy=0

  obj.imgID=Res.SLIDER   --默认对话框背景
  obj.width=49
  obj.height=51
  obj.mDown=0
  obj.onSlide=nil  --回调函数
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function SlideBar:draw() 
    Painter.drawImage(self.imgID,self.x,self.y,0,0)
end

function SlideBar:onLDown(x,y)
    if IN_BOX(MX,MY,self.x,self.y,self.width,self.height)==1 then
     self.mDown=1
	 self.mx=x
	 self.my=y
	 self.ox=self.x
	 self.oy=self.y
	 end
end

function SlideBar:change() --状态改变
    if self.mDown==1 then
       --self.x=MX-self.mx+self.ox
       self.y=MY-self.my+self.oy
	   if self.onSlide then
	      self.onSlide(self.y)
	   end
	end
end