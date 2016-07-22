require("UI")

GridCard=UI:new()

function GridCard:new(x,y,w,h,info)  --构造时指定一个矩形区域
     local obj={}
	 setmetatable(obj,self)
	 self.__index=self
	 ------------------
	 obj.x=x
	 obj.y=y
	 obj.w=w
	 obj.h=h
	 obj.info=info
	 obj.t=0
	 obj.text=""
	 obj.showCard=0
     obj.imgID=Res.CARD
	 obj.imgW=95--123
	 obj.imgH=102--37
	 
	 self.mx=0
	 self.my=0
	 self.curCard=nil
	 return obj
end

function GridCard:draw()
    Painter.setFont("微软雅黑",25)
	Painter.setTextColor(RGB(250,250,160))--200,220,250))
    local x,y
	if self.t<#self.info then
	  self.t=self.t+1
	end
    for i=1,self.t do
	    x=((i-1)%8)*(self.imgW+20)
		y=math.floor((i-1)/8)*(self.imgH+20)
        Painter.drawImage(self.imgID,self.x+x,self.y+y,0,0)
		Painter.drawText(self.x+x+20,self.y+y+35,self.info[i][1][2])
	end
end

function GridCard:onLDown(x,y)
    if  world.focus==nil then
		local xx,yy
		for i=1,self.t do
			xx=((i-1)%8)*(self.imgW+20)
			yy=math.floor((i-1)/8)*(self.imgH+20)
			if IN_BOX(MX,MY,self.x+xx,self.y+yy,self.imgW,self.imgH)==1 then
					local text=""
					 for k,v in pairs(self.info[i]) do
						text=text..v[1]..":  "..v[2].."\n\r\n\r"
					 end
					 local t=TextBox:new(400,200,text)
					 local b1=Button:new(0,0,230,390,"确定")
					 local b2=Button:new(0,0,145,390,"编辑")
					 b1.onClick=function() world:del(t) world.focus=nil end
					 b2.onClick=function() world:del(t) world.focus=nil onEdit(self.info,i)  end
					 self.curCard=t
					 t:addChild(b1)
					 t:addChild(b2)
					 world.focus=t
					 world:add(t)
			end
		end
	end
end

function  onEdit(info,i)
      local box=TextBox:new(400,200,"")
	  box.imgID=Res.BOX2
	  box.width=420
	  box.height=433
	  local edit1=EditCtrl:new(0,0,320,30)
	  local edit2=EditCtrl:new(0,0,320,230)
      edit1.rx=50
      edit1.ry=80
	  edit1.text=info[i][1][1]
      edit2.rx=50
      edit2.ry=150
	  edit2.text=info[i][1][2]
	  local leftBtn=Button:new(0,0,280,120)
	  local rightBtn=Button:new(0,0,310,120)
	  leftBtn.maxFrame=1
      leftBtn.imgID=Res.BUTTON3	  
	  leftBtn.width=30
	  leftBtn.height=24
	  rightBtn.maxFrame=1
      rightBtn.imgID=Res.BUTTON4
	  rightBtn.width=30
	  rightBtn.height=24
------------------	  
	  g_index=1
	  g_key=info[i][1][1]
	  g_value=info[i][1][2]
	  g_new=false
      local function  update()
    	    if g_new==true then  --新建项
			    g_new=false
			    g_InfoChange=true
			    local n=#info[i]+1
				info[i][n]={}
			    info[i][n][1]=edit1.text
                info[i][n][2]=edit2.text				
			elseif edit1.text~=g_key or edit2.text~=g_value then --修改了键
			    g_InfoChange=true
                info[i][g_index][1]=edit1.text
                info[i][g_index][2]=edit2.text			    
			end
	  end
	  leftBtn.onClick=function()
		    update()
	        if g_index==1 then
			    g_index=#info[i]
			else
			    g_index=g_index-1
			end
	        edit1.text=info[i][g_index][1]
	        edit2.text=info[i][g_index][2]
            g_key=	edit1.text
            g_value=edit2.text					
	  end
	  rightBtn.onClick=function()
		    update()
	        if g_index==#info[i] then
			    g_index=1
			else
			    g_index=g_index+1
			end
	        edit1.text=info[i][g_index][1]
	        edit2.text=info[i][g_index][2]
            g_key=	edit1.text
            g_value=edit2.text		
	  end
      local delBtn=Button:new(0,0,180,390,"删除")
	  local okBtn=Button:new(0,0,280,390,"确定")
	  delBtn.onClick=function()
	      g_InfoChange=true
		  if i==#info then
		      info[i]=nil
		  else
			  for j=i,#info-1 do
				 info[j]=info[j+1]
			  end
			  info[#info]=nil
		  end
		 g_InfoCard.t=g_InfoCard.t-1
	      world:del(box)
	  end	  
	  okBtn.onClick=function()
	      update()
	      world:del(box)
		  world.focus=nil
	  end
	  local  newBtn=Button:new(0,0,50,115,"新建")
	  newBtn.onClick=function()
	      g_new=true
		  g_index=#info[i]+1
	      edit1.text=""
		  edit2.text=""
	  end
	  local  clrBtn=Button:new(0,0,140,115,"清除")
	  clrBtn.onClick=function()
	        table.remove(info[i],g_index)
	        if g_index==1 then
			    g_index=#info[i]
			else
			    g_index=g_index-1
			end
	        edit1.text=info[i][g_index][1]
	        edit2.text=info[i][g_index][2]
            g_key=	edit1.text
            g_value=edit2.text	
            g_InfoChange=true			
	  end		  
	  box:addChild(edit1)
      box:addChild(edit2) 
	  box:addChild(okBtn)
	  box:addChild(delBtn)
	  box:addChild(leftBtn)
	  box:addChild(rightBtn)
	  box:addChild(newBtn)
	  box:addChild(clrBtn)
	  world.focus=box
      world:add(box)	  
end

function onNewCard()  --供外部调用新建卡片
      local n=#g_InfoCard.info+1
	  g_InfoChange=true
	  g_InfoCard.info[n]={}
	  g_InfoCard.info[n][1]={"姓名",""}
	  g_InfoCard.info[n][2]={"性别","男"}
	  g_InfoCard.info[n][3]={"学号","0121405830"}
	  g_InfoCard.info[n][4]={"电话","12345678"}
	  g_InfoCard.info[n][5]={"QQ","87654321"}
	  g_InfoCard.info[n][6]={"家乡",""}
	  g_InfoCard.info[n][7]={"祝福语","大学，我们在武汉这座城市一同走过，每一个清晨和夜晚，每一次感动和收获，会一直印在心底"}
	  if g_InfoCard.curCard then
		 world:del(g_InfoCard.curCard)
		 world.focus=nil
		 g_InfoCard.curCard=nil
	  end
      onEdit(g_InfoCard.info,n)  
end
