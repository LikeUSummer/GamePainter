## 编译构建

有下列两种可选的编译构建方式，构建完成后，将`GamePainter.exe`移动到`usage`目录下运行，可以看到演示游戏画面，鼠标右键控制人物移动，左键点击 NPC 会弹出对话框。

### 使用 gn + ninja 构建

前置条件：

- windows 环境
- MSVC 构建工具及 windows SDK

gn 与 ninja 工具已经预置在 build 目录下，可直接执行以下命令：

```shell
build/gn gen -C out
build/ninja -C out
```

### 手动编译

前置条件：

- windows 环境
- clang/LLVM 工具集
- MSVC 构建工具及 windows SDK

执行以下命令：

```shell
cd noumenon
clang++ main.cpp ui/win.cpp lua/lua_machine.cpp utils/*.cpp -o GamePainter.exe -Iui -Ilua -Iutils -Llua/bin -llua_static -luser32 -lgdi32 -lgdiplus -lwinmm -lImm32
```

注：如果引用了第三方使用 VC 编译出的库，为避免 VC 运行时库的冲突（无法解析符号等），可在上述编译命令后追加 `-lmsvcrt -llibcmt`

