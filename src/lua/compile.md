# 手动编译 lua 依赖

### 编译 lua 静态库

```shell
clang -c src/*.c
lib *.o
del *.o
```

其中`lib`来自 msvc 工具链，请注意配置相关路径。

### 编译 lua c++ wrapper 测试程序

```shell
clang++ *.cpp ../utils/*.cpp -o test_lua_wrapper.exe -I../utils/ -L./bin/ -llua_static
```

