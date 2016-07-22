require("UI")
--[[
这个文本编辑框控件应该是编写工作量最大的控件之一，
一番调试和修改，终于完成了，目前选中功能还没有，
但其余基础功能都写进去了         大夏天2015
]]
EditCtrl=UI:new()

function EditCtrl:new(x,y,w,h)  --构造时指定一个矩形区域
     local obj={}
	 setmetatable(obj,self)
	 self.__index=self
	 ------------------
	 obj.x=x  --控件位置
	 obj.y=y
	 obj.rx=0
	 obj.ry=0
	 obj.crtX=0  --插字符位置（局部坐标）
	 obj.crtY=0
	 obj.crtN=0 --插字符索引
	 obj.lastX=0
	 obj.lastY=0
	 obj.charH=20
	 obj.width=w
	 obj.height=h
	 obj.text=""
	 obj.line=1
	 obj.lineHead={}  --每行首字符索引（用于加速插入点计算）
	 obj.focus=false  --是否处于焦点
     obj.imgID=Res.EDIT_BOX   --背景图可以大一点，方便裁剪不同尺寸
	 
	 self.mx=0
	 self.my=0
	 self.timer=0
	 return obj
end

function EditCtrl:draw()
    Painter.setFont("微软雅黑",self.charH)
	if self.focus==true then  --绘制插字符
		if self.timer<6 then
			 Painter.drawLine(self.crtX+self.x,self.crtY+self.y,self.crtX+self.x,self.crtY+self.y+self.charH)
		end
		if self.timer==10 then
		   self.timer=0
		end
		self.timer=self.timer+1
	end
    Painter.drawImageR(self.imgID,self.x,self.y,0,0,self.width,self.height) --绘制背景
	--绘制文本
     self:drawChars()
end

function EditCtrl:drawChars() --格式化绘制文本
   	local w,h
	local x=0
	local y=0
	local i=1
	local word=""
	self.line=1
	while i<=#self.text do
         word=self:getChar(i)
		 if word=="\r" then
		     y=y+self.charH
			 x=0			 
		 else
			 w,h=Painter.getTextSize(word,#word)
			 if x+w>self.width then
				 y=y+self.charH
				 x=0
			 end
		    Painter.drawText(self.x+x,self.y+y,word)
			 if x==0 then
			   self.lineHead[self.line]=i   --创建行首标记
			   self.line=self.line+1
			 end
		     x=x+w 
		 end	

		 i=i+#word
	end
end

function EditCtrl:getChar(i) --获取一个完整字符(返回字符串)
        local word=""
		if self.text:byte(i)>0xA0 then  --GB2312字符
		   word=self.text:sub(i,i+1)
		else  --ASCII
		   word=self.text:sub(i,i)		   
		end     
		return word
end

function EditCtrl:mouseToCaret(x,y) --把鼠标位置转换成插字符位置
    if #self.text==0 then
	   return 0,0,0
	end
	local xx=0
	local word=""
	local w,h
	local line=math.ceil((y-self.y)/self.charH)
	if line>self.line then
	   line=self.line
	 end
	local i=self.lineHead[line]  --行首字符的索引
	while xx+self.x<x do
	    if i>#self.text  then
		     if #word==2 then
		        return i-#word+1,xx,self.charH*(line-1)  
			else
		        return i-#word,xx,self.charH*(line-1) 
            end				
		 end
         word=self:getChar(i)
	     i=i+#word
	     w,h=Painter.getTextSize(word,#word)
		 xx=xx+w
		 if xx>self.width or word=="\r"  then
		     return i-#word-1,xx-w,self.charH*(line-1) 
		 end
	end 
	local n
	n=i-#word-1 --插字符左边的字符尾字节
     return n,xx-w,self.charH*(line-1)    
end

function EditCtrl:getCharPos(k) --获取第k个字符的位置（局部坐标）
    if k<1 then 
	   return 0,0
	end
    local w,h
	local x=0
	local y=0
	local i=1
	local word=""
	while i<=k do
         word=self:getChar(i)
		 if word=="\r" then
		     y=y+self.charH
			 x=0		     
		 else
			 w,h=Painter.getTextSize(word,#word)
			 if x+w>self.width then
				 y=y+self.charH
				 x=0
			 end
		     x=x+w
		 end
		  i=i+#word
	end   
	return x,y
end

function EditCtrl:onLDown(x,y)
    if IN_BOX(MX,MY,self.x,self.y,self.width,self.height)==1 then
		 self.focus=true
		 self.crtN,self.crtX,self.crtY=self:mouseToCaret(x,y)
		 Painter.setIMEPos(self.crtX+self.x,self.crtY+self.y+self.charH+20)  --把输入法窗口移动到插字符下方
	 else
		 self.focus=false
	 end
end

function EditCtrl:onCKeyDown(word,nRep) 
      if self.focus==true then
         local w,h
	     local del=""
			 if word:byte(1)==0x8 then--处理退格
			       if self.crtN>0 then
						if self.text:byte(self.crtN)>0xA0 then--取出待删除的字符
							 del=self.text:sub(self.crtN-1,self.crtN)
						else
							 del=self.text:sub(self.crtN,self.crtN)
						end
						 w,h=Painter.getTextSize(del,#del) --计算尺寸
						 self.crtX=self.crtX-w
                         if self.crtX<=0 then --如果本行结束则重算插字符
		                      self.crtX,self.crtY=self:getCharPos(self.crtN-#del)
						 end	
						 local str=self.text:sub(1,self.crtN-#del)..self.text:sub(self.crtN+1,#self.text)
						 self.text=str
						 self.crtN=self.crtN-#del
					end
			 else
					local str=self.text:sub(1,self.crtN)..word..self.text:sub(self.crtN+1)
					self.text=str
					self.crtN=self.crtN+#word
					 if word=="\r" then--处理回车
							self.crtX=0
							self.crtY=self.crtY+self.charH
					 else
							 w,h=Painter.getTextSize(word,#word)
							 self.crtX=self.crtX+w
							 if self.crtX>self.width then
								self.crtX=w
								self.crtY=self.crtY+self.charH
							 end
					 end
			 end--退格
	  end--focus
end