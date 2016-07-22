Atom={}
--约定所有粒子质量为1
K_G=-100  --引力系数
K_R=100   --斥力系数
DT=0.01           --时间间隔
COUNT=100

function Atom:new(x,y)
    local obj={}
	setmetatable(obj,self)
	self.__index=self
	obj.atoms={}
--[[	for i=1,100 do      --随机粒子云
	   obj.atoms[i]={}
	   obj.atoms[i].x=x+math.random(300) --粒子云长300
	   obj.atoms[i].y=y+math.random(50)   --粒子云高50
	   obj.atoms[i].fx=0  --粒子受力
	   obj.atoms[i].fy=0
	   obj.atoms[i].vx=0 --粒子速度
	   obj.atoms[i].vy=0
	end
	 obj.atoms[1].x=615
	 obj.atoms[1].y=400--]]

 for i=1,4 do             --规则晶格
	     for j=1,25 do
	   obj.atoms[i*25-25+j]={}
	   obj.atoms[i*25-25+j].x=x+(j-1)*20
	   obj.atoms[i*25-25+j].y=y+(i-1)*20
	   obj.atoms[i*25-25+j].fx=0  --粒子受力
	   obj.atoms[i*25-25+j].fy=0
	   obj.atoms[i*25-25+j].vx=0 --粒子速度
	   obj.atoms[i*25-25+j].vy=0
		 end
	 end

	return obj
end

function Atom:update()
    self:Process()
	 for i=1,COUNT do
		    self.atoms[i].x=self.atoms[i].x+self.atoms[i].vx*DT  --位置在这里更新，以保证相互之间同时作用
		    self.atoms[i].y=self.atoms[i].y+self.atoms[i].vy*DT
		    Painter.drawImage(Res.ATOM,self.atoms[i].x,self.atoms[i].y,0,0,0,0)
	 end
end

function Atom:Process()
	 local fx,fy,dx,dy
	 local j
	 for i=1,COUNT do
	     j=1
		 self.atoms[i].fx=0
	     self.atoms[i].fy=0
		 while j<=COUNT do  --计算第i个粒子受的合力
		     if i~=j then
 	             dx=self.atoms[i].x-self.atoms[j].x
	             dy=self.atoms[i].y-self.atoms[j].y
                 fx,fy=self:WeiGuan(dx,dy)     --选择一种粒子间作用力模型处理
	             self.atoms[i].fx=self.atoms[i].fx+fx
	             self.atoms[i].fy=self.atoms[i].fy+fy
			 end
			 j=j+1
		 end
		 if i==1 then
		    --self:ExtForce()    --编辑并开启这个函数可对一些粒子施加额外力
		 end
	     self.atoms[i].vx=self.atoms[i].vx+self.atoms[i].fx*DT  --更新速度，由于质量为1，所以f等于a
	     self.atoms[i].vy=self.atoms[i].vy+self.atoms[i].fy*DT
	 end
end

------------在下面区域可新建一些相互作用力模型------------------
function  Atom:TanLi(dx,dy) --弹力
   local fx=K_G*dx
   local fy=K_G*dy
   return fx,fy
end

function Atom:WeiGuan(dx,dy) --假想的微观力，在某个范围内是斥力，反之是引力
     local  r=dx*dx+dy*dy
     if math.sqrt(r)>5 then
        return self:YinLi(dx,dy)
     else
        return self:ChiLi(dx,dy)
     end
end

function Atom:YinLi(dx,dy) --引力
    local  r=dx*dx+dy*dy
	local fx=0
	local fy=0
	local c,s
	if r~=0 then
	    c=dx/math.sqrt(r)
		s=dy/math.sqrt(r)
		fx=K_G*c/r
		fy=K_G*s/r
	end
	return fx,fy
end

function Atom:ChiLi(dx,dy) --斥力
    local  r=dx*dx+dy*dy
	local fx=0
	local fy=0
	local c,s
	if r~=0 then
	    c=dx/math.sqrt(r)
		s=dy/math.sqrt(r)
		fx=K_R*c/r
		fy=K_R*s/r
	end
	return fx,fy
end

function Atom:ExtForce() --外力
    self.atoms[1].fx=self.atoms[1].fx+0 --这里对其中一个粒子施加恒力
	self.atoms[1].fy=self.atoms[1].fy+100
end
-----------------------------------------------------------------



