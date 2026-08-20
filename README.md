# ohos-native-bindings-demos

ArkTS UI 宿主工程，对接 [ohos-native-bindings](../ohos-native-bindings) 仓库的 Rust 层 examples。
每个 demo 一个页面（菜单导航），通过构建脚本消费 bindings 仓库构建出的 `.so` / `index.d.ts`。

## 前置

- Rust + [ohrs](https://github.com/ohos-rs/ohrs)（构建 Rust examples）
- [arkdown](https://www.npmjs.com/package/@ohos-rs/arkdown)（hap 打包），`OHOS_SDK_HOME` 已配置
- Node.js + pnpm（`prek` / `oxk` 为 devDependencies）
- hdc（真机连接）

## 使用

```sh
pnpm install            # 安装 prek / oxk / rimraf
pnpm exec prek install  # 安装 git pre-commit hooks（提交前自动 oxk format + lint）

pnpm sync:rust          # 构建 bindings 仓库全部 example 并拷贝 .so/.d.ts（或 pnpm sync:rust -- arkui 单个）
pnpm build:hap          # arkdown 打包 debug hap
pnpm install:hap        # hdc 安装 hap 到真机
pnpm start              # 启动真机上的 app
pnpm test               # 打包并在真机上跑 ohosTest（Hypium 直接调用各 binding napi）
pnpm run                # 一条龙：sync:rust -> build:hap -> install:hap -> start

pnpm format             # oxk 格式化全部 ArkTS
pnpm lint               # oxk lint
pnpm check              # prek 跑全部 hooks
pnpm clean              # 清理构建产物
```

bindings 仓库定位：默认取同级目录 `../ohos-native-bindings`；作为 submodule 检出时取父目录；
也可用环境变量 `OHOS_NATIVE_BINDINGS=<path>` 覆盖。

## 提交前检查（prek + oxk）

`.pre-commit-config.yaml` 定义了三个 hook，`git commit` 时自动执行：

1. **oxk format** — 格式化暂存的 `.ets` 文件（若发生改动会拒绝本次提交，`git add -u` 后重新提交即可）
2. **oxk lint** — lint 暂存的 `.ets` 文件（error 阻断，warning 放行）
3. **block generated artifacts** — 阻止提交 `entry/libs/`、`entry/src/main/ets/types/` 下的生成产物（由 `scripts/sync-rust.sh` 同步）

## 目录约定

- Rust 层 demo：bindings 仓库 `examples/`（本仓库不包含 Rust 代码）；每个 example 的 cargo 包名统一为 `<demo>_test`，产物为 `lib<demo>_test.so` —— `_test` 后缀避免 ESM 模块名与系统模块（qos、ability_access_control 等）冲突
- `entry/libs/`、`entry/src/main/ets/types/`：生成产物，不入库
- `entry/src/main/ets/pages/`：每个 binding 一个 demo 页面 + 菜单页；`OhosTestHost.ets` 是 ohosTest 的宿主页面（XComponent / NodeContent / Web surface）
- `entry/src/ohosTest/`：标准 ohosTest 源码集（Hypium）。测试用例按模块拆分在 `ets/test/modules/<Binding>.test.ets`，由 `List.test.ets` 聚合。`pnpm test` 会先 `pnpm start` 启动主 app（宿主页面加载各 XComponent/Web surface），再 `aa test` —— TestAbility 与 EntryAbility 同进程，测试代码可直接驱动同一批 napi .so 的进程级状态。arkdown 无法为 entry_test 注册路由页面（TestAbility `loadContent` 报 page not found），所以宿主 surface 放在主模块。OpenGTX 不在 OpenHarmony NDK 里，需 HMS SDK 时单独 `pnpm sync:rust -- opengtx`。

HMS OpenGTX 需要 HMS 的 `libopengtx`，不在 OpenHarmony NDK 里。有 HMS SDK 时单独 `pnpm sync:rust -- opengtx`。
