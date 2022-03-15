## 编译构建

有两种可选的编译构建方式：

### 手动编译

```shell
cd src
clang++ main.cpp lua/lua_machine.cpp utils/*.cpp -o GamePainter.exe -L./lua/bin/ -llua_static -luser32 -lgdi32 -lgdiplus -lwinmm -lImm32
```

注：如果引用了第三方使用 VS 编译出的库，为避免 VC 运行时库的冲突（无法解析符号等），可在上述编译命令后追加 `-lmsvcrt -llibcmt`

### 使用 gn + ninja 构建

```shell
build/gn gen -C out
build/ninja -C out
```

