NPC=Life:new() --其他角色的基类

function NPC:new()
  local obj={}
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function NPC:onLDown(x,y)  --NPC响应左键单击
    if self:near(x,y)==1 then
       self:storyBegin()
   end
end

function NPC:storyBegin()

end

--程序开源 ，请勿用于商业开发
--怎么去拥有一道彩虹，怎么去拥抱一夏天的风       大夏天2015