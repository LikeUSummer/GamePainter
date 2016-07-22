--状态描述类
--[[
我个人觉得把对象状态单独用一个结构描述是比较可行的，无论是全局使用还是每个对象私有都是可以的；
如果是创建全局状态，可以用来描述主角等重要对象状态，便于其他辅助对象的实时访问检测，而且结构化
后方便管理，避免过多的全局变量名混淆；如果是每个对象各自使用，如可以给每个辅助对象如NPC等绑定
这样一个状态结构，可以用于自身数据管理。由于非重要对象一般情况下不用精细了解其状态，所以在某些
对象需要的状态变量不多时，可自行定义变量，节约资源
--]]
State={}

function State:new()
  local obj={}
  obj.life=100  --生命值
  obj.level=1    --等级
  obj.power=10  --攻击力
  obj.defense=10 --防御力
  obj.attacking=0  --是否处于攻击状态
  obj.frequency=1 --每秒攻击次数

  obj.atkX=-1 --攻击域中心（屏幕坐标）
  obj.atkY=-1
  obj.atkRange=500   --攻击范围
  
  setmetatable(obj,self)
  self.__index=self
  return obj
end
