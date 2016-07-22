require("UI")

TextBox=UI:new()  --文本框类
function TextBox:new(x,y,text)
  local obj={}
  obj.x=x
  obj.y=y
  obj.textX=89
  obj.textY=69
  obj.lineChars=16  --每行字符数
  obj.text=text
  obj.len=string.len(text)/2  --中文
  obj.lock=0  --是否固定
  obj.mx=0  --鼠标左键按下的位置
  obj.my=0
  obj.ox=0   --鼠标左键按下时控件位置
  obj.oy=0
  obj.child={}  --子控件表
  obj.imgID=Res.BOX1   --默认对话框背景
  obj.width=331
  obj.height=429
  obj.mDown=0
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function TextBox:draw()
    Painter.setFont("宋体",12)
    Painter.setTextColor(RGB(179,177,137)) 
	Painter.drawImage(self.imgID,self.x,self.y,0,0)
    Painter.drawTextR(self.text,self.x+20,self.y+20,self.x+self.width-20,self.y+self.height-20,0x2010)
	for k,v in pairs(self.child) do
	   v.x=self.x+v.rx
	   v.y=self.y+v.ry
       v:draw()
     end
end

function TextBox:onLDown(x,y)
    for i=1,#self.child do
       self.child[i]:onLDown(x,y)
    end
    if IN_BOX(MX,MY,self.x,self.y,self.width,self.height)==1 then
     self.mDown=1
	 self.mx=x
	 self.my=y
	 self.ox=self.x
	 self.oy=self.y
	 end
end

function TextBox:onLUp(x,y)
    for k,v in pairs(self.child) do
         v:onLUp(x,y)
    end
    self.mDown=0
end

function TextBox:change() --状态改变
    for k,v in pairs(self.child) do
       v:change()
    end
    if self.mDown==1 then
       self.x=self.ox+MX-self.mx
       self.y=self.oy+MY-self.my
	end
end

--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015



