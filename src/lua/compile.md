# 手动编译 lua 依赖

### 编译 lua 静态库

```shell
clang -c src/*.c
lib *.o
del *.o
```



### 编译 lua c++ wrapper 测试程序

```shell
clang++ *.cpp ../utils/*.cpp -o test_lua_wrapper.exe -L./bin/ -llua_static
```

