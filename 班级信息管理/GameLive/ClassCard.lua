require("UI")
require("OSFindFile") --采用dos命令dir来遍历目录，如果运行失败，可试用IFSFindFile模块
require("GridCard")

ClassCard=UI:new()

function ClassCard:new(x,y,w,h)  --构造时指定一个矩形区域
     local obj={}
	 setmetatable(obj,self)
	 self.__index=self
	 ------------------
	 obj.x=x
	 obj.y=y
	 obj.w=w
	 obj.h=h
	 obj.info=getAllFiles("ClassInfo\\")
	 obj.text={}
	 obj.t=0  --当前最大索引（用于动画）
	 obj.enable=1
	 obj.editing=0
	 obj.originName=""
     obj.imgID=Res.CARD2
	 obj.imgW=150
	 obj.imgH=115
	 obj.mx=0
	 obj.my=0
	 for i=1,#obj.info do
	    local  j,k=obj.info[i]:find("/.*%.")
		obj.text[i]=obj.info[i]:sub(j+1,k-1)
	 end
	 return obj
end

function  ClassCard:refrash()
	 for i=1,#self.info do
	    local j,k=self.info[i]:find("/.*%.")
		self.text[i]=self.info[i]:sub(j+1,k-1)
	 end
end

function ClassCard:draw()
    Painter.setFont("微软雅黑",25)
	Painter.setTextColor(RGB(200,220,250))
    local x,y
	if self.t<#self.info then
	  self.t=self.t+1
	end
    for i=1,self.t do
	    x=((i-1)%6)*(self.imgW+20)
		y=math.floor((i-1)/6)*(self.imgH+20)
        Painter.drawImage(self.imgID,self.x+x,self.y+y,0,0)
		Painter.drawText(self.x+x+30,self.y+y+45,self.text[i])
		if  g_DelClass==true then
		     Painter.drawImage(Res.DELETE,self.x+x+40,self.y+y+40,0,0)
			 Painter.drawText(200,690,"提示：单击卡片将删除对应数据库，点击\"完成\"按钮可解除当前状态")
		end
	end
end

function ClassCard:onLDown(x,y)
    local xx,yy
	local clicked=0
    for i=1,self.t do
	    xx=((i-1)%6)*(self.imgW+20)
		yy=math.floor((i-1)/6)*(self.imgH+20)
        if IN_BOX(MX,MY,self.x+xx,self.y+yy,self.imgW,self.imgH)==1 then
		    if self.editing==0 then
			      if g_DelClass==true  then
				        os.remove(self.info[i])
				        table.remove(self.info,i)
						table.remove(self.text,i)
						self.t=self.t-1
				  else
					  local j,k=self.info[i]:find("/.*%.")
					  local name=self.info[i]:sub(1,k-1)
					  local info=require(name)	
					  local card=GridCard:new(150,120,1000,1000,info)
					  --传递全局信息
					  g_Info=info
					  g_InfoPath=self.info[i]
					  g_InfoCard=card
					  g_InfoChange=false
					  g_NewCardButton.onClick=onNewCard
					  g_Slider.onSlide=function(y)  card.y=-y+160 end
					  world:add(card)
					  world:add(g_RtnButton) --显示按钮
					  world:del(g_NewClassButton)
					  world:del(g_DelClassButton)
					  world:add(g_NewCardButton)
					  self.enable=0
					  world:del(self)
					end
			 end
             clicked=1
		end
	end--for
	---重命名处理
	if clicked==0 then
	  if self.editing>0 then
		   if g_NameEdit.text:find("%s") or g_NameEdit.text=="" then
		      self.text[self.editing]=self.originName
		   else
 		      self.text[self.editing]=g_NameEdit.text
		   end
		   local j,k=self.info[self.editing]:find("/.*%.")
		   local originPath=self.info[self.editing]
		   self.info[self.editing]=self.info[self.editing]:sub(1,j)..self.text[self.editing]..".lua"
		   world:del(g_NameEdit)
		   if  self.text[self.editing]~=self.originName then
		        os.rename(originPath,self.info[self.editing])
		   end
		   self.editing=0
	  end	
	end
end

function ClassCard:onRDown(x,y)
    local xx,yy
    for i=1,self.t do
	    xx=((i-1)%6)*(self.imgW+20)
		yy=math.floor((i-1)/6)*(self.imgH+20)
        if IN_BOX(MX,MY,self.x+xx,self.y+yy,self.imgW,self.imgH)==1 then
		   if  self.editing==0 then
               g_NameEdit.x=self.x+xx+20
			   g_NameEdit.y=self.y+yy+50
			   g_NameEdit.text=self.text[i]
			   self.originName=self.text[i]
			   self.text[i]=""
			   world:add(g_NameEdit)
		       self.editing=i	
		    end
		end
	end
end

function saveThread()
   saveInfo(g_InfoPath,g_Info)
end
function  saveInfo(path,info) --存储信息到文件，实际是在重写脚本
      local f=io.open(path,"w")
	  f:write("local class={}\n")
	  for i=1,#info do
	       f:write("class["..i.."]={}\n")
	       for j=1,#info[i] do
  	          f:write("class["..i.."]["..j.."]={\""..info[i][j][1].."\",\""..info[i][j][2].."\"}\n")             
		   end
	  end
	  f:write("return class\n")
	  f:close()
end

function  onNewClass()
     local n=#g_Class.info+1
	 local id=os.date("%M%S",os.time())
     g_Class.info[n]="ClassInfo/未命名"..id..".lua"
     g_Class.text[n]="未命名"..id
	 local info={}
	 saveInfo(g_Class.info[n],info)
end

