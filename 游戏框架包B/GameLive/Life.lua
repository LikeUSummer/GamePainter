--所有活动元素的基类
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
Life={}
function Life:new()
  local obj={}
  obj.ID=0           --对象在世界管理器中的ID
  obj.x=0
  obj.y=0
  obj.wx=0
  obj.wy=0
  obj.animation={} --对象的动画管理器
  obj.direction=WEST--朝向
  obj.timer=16    --计数器
  obj.life=100     --生命值
  obj.speed=0    --移动速度
  obj.changed=0  --状态改变标志
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function Life:update()  --对外界更新，成员函数
    self:transXY()
    self:change()
    self:draw()
end

function Life:draw()
    self.animation:show(self.x,self.y)
end

function Life:change()  --状态更新，由具体角色实现

end

function Life:transXY()  --坐标变换（对象依赖于地图,self.x是绘图坐标，self.wx是世界坐标）
    self.x=self.wx+WX
    self.y=self.wy+WY
end
function Life:onLDown(x,y)

end

function Life:onRDown(x,y)

end

function Life:onLUp(x,y)

end

