--采用dos命令dir来遍历目录，如果运行失败，可试用IFSFindFile模块
function  getAllFiles(path)
   info = io.popen("dir "..path.." /b")
   local fileArr={}
   local i
   for line in info:lines() do
       i=#fileArr+1
	   line=path..line
	   line=line:gsub("\\","/")
       fileArr[i]=line
   end
   return fileArr
end