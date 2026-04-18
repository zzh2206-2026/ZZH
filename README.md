# 星元 · 谜语 · Boss（SFML 单人平台）

## 依赖

- CMake 3.16 或更高（Visual Studio 2022 自带 CMake 亦可）  
- C++17 编译器（推荐 **Visual Studio 2022** 勾选「使用 C++ 的桌面开发」）  
- 网络（首次配置会 **下载 SFML 2.6.2 源码 ZIP**，不再需要安装 Git）

**路径建议**：工程放在 **纯英文路径**（如 `C:\dev\StarYuan`）。放在含中文的桌面文件夹时，部分环境会出现 CMake 配置异常退出。

中文字体：程序会依次尝试 `assets/fonts/msyh.ttc`、`assets/fonts/simhei.ttf` 与常见 Windows 系统字体路径。也可自行将 `msyh.ttc` 放到 `assets/fonts/`。

## 构建（Windows 命令行，推荐）

在项目根目录双击或运行 **`build_and_run.bat`**（已写好 VS 2022 的 CMake 路径；若首次下载 SFML 失败会自动换镜像重试）。

或手动在 **「x64 Native Tools Command Prompt for VS 2022」** / **cmd** 中执行：

```bat
cd /d 你的工程目录
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -S . -B build -G "Visual Studio 17 2022" -A x64
cmake --build build --config Release
cd build\Release
star_yuan_game.exe
```

若提示无法下载 SFML，可改用镜像再配置一次（与 `build_and_run.bat` 中一致）：

```bat
cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DSFML_ZIP_URL=https://ghproxy.net/https://github.com/SFML/SFML/archive/refs/tags/2.6.2.zip
```

**Win11 / 界面「卡住」很久不动**：多半是在后台下载 SFML 压缩包（十几 MB），请多等几分钟；若多次失败，请把工程移到 **全英文路径**（例如 `D:\dev\StarYuan`），并删除整个 `build` 文件夹后重试。

**离线 SFML（推荐网络不稳定时使用）**：用浏览器下载 [SFML 2.6.2 源码 zip](https://github.com/SFML/SFML/archive/refs/tags/2.6.2.zip)，解压后将文件夹放到工程里的 `third_party/sfml/`（保证存在 `third_party/sfml/CMakeLists.txt`），再删掉 `build` 后运行 `build_and_run.bat`，将不再联网下载。详见 [third_party/README.txt](third_party/README.txt)。

非 Windows / 单配置生成器示例：

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

生成后的可执行文件在 `build/Release/`（VS 生成器）或 `build/`（Ninja 等）。构建脚本会把 `assets` 以及 **SFML 的 DLL**（`sfml-system-2.dll`、`sfml-window-2.dll`、`sfml-graphics-2.dll`）复制到可执行文件同目录。

若仍提示缺少 DLL，请重新执行一次 **`cmake --build build --config Release`**（需使用已更新过的 `CMakeLists.txt`）；或手动从 `build/_deps/sfml-build/lib/Release/` 将上述三个 `sfml-*-2.dll` 拷到 `build/Release/`。

## 操作

- **关卡**：A / D 或方向键左右移动，**Space** 跳跃；地图上共有 **10** 个星元，但每名玩家**最多只能拾取 5 个**（达到上限后其余星元仍在场上，但无法再拾取）。  
- **谜语**：拾取后出现对话框；**Esc** 跳过（不消耗作答次数）；**Enter** 提交答案。全游戏共 **3** 次作答机会；答对获得额外属性（地图最右上角金色星元奖励更高）。  
- **Boss 战**：拾取第 **5** 个星元并关闭谜语界面后进入；顶部显示双方血量；**J 迅斩**（短冷却近战）、**K 重击**（高伤、冷却中等）、**L 闪步**（短位移，撞到 Boss 追加伤害，冷却较长）；血条下方三色短条为三个技能的冷却进度。避免与 Boss 长时间重叠。

## 规则摘要

- 每个星元拾取即获得基础属性加成。  
- 谜语可选做；仅在选择提交答案时消耗作答次数。  
- 全图 10 个星元，拾取满 5 个后关闭当前谜语界面即传送到 Boss。
