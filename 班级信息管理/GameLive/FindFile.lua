--采用IFS.dll来遍历目录，如果运行失败，可试用OSFindFile模块
require("lfs")

function getAllFiles(rpath,buf)
    local files =buf or {}
    for entry in lfs.dir(rpath) do
        if entry ~= '.' and entry ~= '..' then
            local path = rpath .. '/' .. entry
            local attr = lfs.attributes(path)
            assert(type(attr) == 'table')

            if attr.mode == 'directory' then
                 getAllFiles(path,files)
            else
                table.insert(files, path)
            end
        end
    end
    local fileArr={}
    for k,v in pairs(files) do
       fileArr[#fileArr+1]=v
    end
    return fileArr
end
