--所有活动元素的基类
--由于大多数属性都不具有公用性，所以这里Life只进行部分方法上的规范
--[[
变量名约定
x,y      屏幕坐标(这个坐标表示对象的基准点，一般选脚下正中位置)
wx,wy 世界坐标(相对背景地图的)
animation  对象的动画管理对象
从Life派生的对象至少包含这些变量
]]

Life={}
function Life:new()
  local obj={}
--[[
  obj.x=0     --这里的变量只是起名称约定作用，派生出的上层类应该重新定义，否则会产生公用逻辑错误
  obj.y=0     --具体使用方法请参考框架中其他从Life派生的模块，以便熟悉这种模式
  obj.wx=0
  obj.wy=0
  obj.animation={}
--]]
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function Life:update()  --对外界更新
    self:transXY()
    self:change()
    self:draw()
end

function Life:draw() --绘制图像
    self.animation:show(self.x,self.y)
end

function Life:change()  --状态更新，由具体角色实现

end

function Life:transXY()  --坐标变换（对象依赖于地图,self.x是屏幕坐标，self.wx是世界坐标）
    self.x=self.wx+WX
    self.y=self.wy+WY
end

function Life:onLDown(x,y)

end

function Life:onRDown(x,y)

end

function Life:onLUp(x,y)

end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015
