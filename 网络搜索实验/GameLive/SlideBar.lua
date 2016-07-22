require("UI")
SlideBar=UI:new()

function SlideBar:new(x,y)
  local obj={}
  obj.x=x
  obj.y=y
  obj.pathX=x+3
  obj.pathY=0

  obj.mx=0  --鼠标左键按下的位置
  obj.my=0
  obj.ox=0   --鼠标左键按下时控件位置
  obj.oy=0

  obj.imgID=Res.SLIDER   --默认对话框背景
  obj.width=49
  obj.height=51
  
  obj.onSlide={}  --回调函数
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function SlideBar:draw() 
    --Painter.drawImage(Res.SLIDER_PATH,self.pathX,self.pathY,0,0)   
    Painter.drawImage(self.imgID,self.x,self.y,(self.frame-1)*self.width,self.width)
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
    for k,v in pairs(self.child) do
       v:change()
    end
    if self.mDown==1 then
       --self.x=MX-self.mx+self.ox
       self.y=MY-self.my+self.oy
	   self.onSlide(self.y)
	end
end