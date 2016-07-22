--界面交互控件的基类
UI={}
function UI:new()
  local obj={}
  --这里的变量只是起名称约定作用，派生出的上层类应该重新定义，否则会产生公用逻辑错误
  obj.mDown=0  --鼠标左键是否按下
  obj.imgID=-1
  obj.width=0
  obj.height=0
  obj.frame=1   --当前帧
  obj.enable=1  --控件是否可用
  obj.child={}    --子控件表
  obj.nChild=0  --子控件数量
  obj.mx=0
  obj.my=0
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function UI:update()  --对外界更新，成员函数
if self.enable==1 then
    self:change()
    self:draw()
end
end

function UI:draw()
    Painter.drawImage(self.imgID,self.x,self.y,(self.frame-1)*self.width,self.width)
end

function UI:change()

end

function UI:onLDown(x,y)
    for k,v in pairs(self.child) do
       v:onLDown(x,y)
    end
    if IN_BOX(MX,MY,self.x,self.y,self.width,self.height) then
        self.mDown=1
    end
end

function UI:onLUp(x,y)
    for k,v in pairs(self.child) do
       v:onLUp(x,y)
    end
    self.mDown=0
end

function UI:onRDown(x,y)
    for k,v in pairs(self.child) do
       v:onRDown(x,y)
    end
end

function UI:addChild(obj)
   self.nChild=self.nChild+1
   self.child[self.nChild]=obj
end

--程序开源，请勿用于商业或不良游戏制作     大夏天2015
