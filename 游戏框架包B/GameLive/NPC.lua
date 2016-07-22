NPC=Life:new() --其他角色的基类
--程序开源，版权保留，请勿用于商业或不良游戏制作     大夏天2015
function NPC:new()
  local obj={}
  setmetatable(obj,self)  --新建对象
  self.__index=self   --设置基类(元表)的__index为自身，使得派生表可访问自身成员
  return obj
end

function NPC:onRDown(x,y)
     if self:near(x,y)==1 then
       slef:storyBegin()
     end
end

function NPC:onLDown(x,y)  --NPC响应左键单击
    if self:near(x,y)==1 then
       self:storyBegin()
   end
end


function NPC:change() --状态改变

end
