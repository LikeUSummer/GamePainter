charH=13  --字高
charW=13
btnX=302
btnY=190

function chineseSub(str,i,j) --汉字串截取，GB编码
 local start=2*(i-1)+1
  return str:sub(start,2*j)
end

TextBox=UI:new()  --文本框类
function TextBox:new(x,y,text)
  local obj={}
  obj.x=x
  obj.y=y
  obj.wx=x-WX
  obj.wy=y-WY
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
  obj.imgID=Res.BOX_TEXT   --默认对话框背景
  obj.width=380
  obj.height=240
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function TextBox:draw()
	local i=1  --字索引
	local j=0  --行数
    if self.lock==1 then
       self.x=self.wx+WX
       self.y=self.wy+WY
    end
	Painter.drawImage(self.imgID,self.x,self.y,0,0)
	while i<self.len do
	   if i+self.lineChars <self.len  then
          Painter.drawText(self.x+self.textX,j*charH+self.y+self.textY,chineseSub(self.text,i,i+self.lineChars))
		  j=j+1  --换行
		else
          Painter.drawText(self.x+self.textX,j*charH+self.y+self.textY,chineseSub(self.text,i,self.len))
		end
		i=i+self.lineChars
	end
	for k,v in pairs(self.child) do
	   v.x=self.x+v.rx
	   v.y=self.y+v.ry
       v:draw()
     end
end

function TextBox:onLDown(x,y)
    for k,v in pairs(self.child) do
       v:onLDown(x,y)
    end
    if IN_BOX(MX,MY,self.x,self.y,self.width,self.height)==1 then
     self.mDown=1
	 self.mx=x
	 self.my=y
	 self.ox=self.x
	 self.oy=self.y
	 end
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



