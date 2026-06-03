# Dreamina Codex Plugin

Dreamina Codex Plugin 是一个面向 Codex 的本地插件，用来调用本机已经安装好的 `dreamina` CLI，在 Codex 中使用即梦 / Dreamina 的图片生成、视频生成、任务查询、积分查询和登录会话管理能力。

> 本项目只封装本地 CLI，不包含 Dreamina / 即梦官方服务，也不绕过任何账号、积分、授权或合规限制。生成任务可能消耗你的 Dreamina 积分。

## 功能概览

- 文生图：`text2image`
- 图生图：`image2image`
- 图片高清放大：`image_upscale`
- 文生视频：`text2video`
- 图生视频：`image2video`
- 首尾帧 / 参考帧视频：`frames2video`
- 多帧故事视频：`multiframe2video`
- 全能参考视频：`multimodal2video`
- 异步任务结果查询：`query_result`
- 历史任务列表：`list_task`
- 账号积分查询：`user_credit`
- 登录、无头登录检查、重新登录、退出登录：`login`、`checklogin`、`relogin`、`logout`
- CLI 版本和能力发现：`version`、`list_capabilities`

插件默认用中文与用户沟通；除非用户明确要求英文，说明、警告、结果总结和交互提示都会使用中文。

## 前置条件

1. 已安装 Codex，并支持本地插件。
2. 已安装本地 `dreamina` CLI，并且命令在 `PATH` 中可用。
3. 你拥有可用的 Dreamina / 即梦账号。
4. 如需提交生成任务，请确认账号积分充足。

检查 CLI 是否可用：

```bash
dreamina -h
dreamina version
```

如果还没有登录，可以在 Codex 中通过插件执行登录，也可以先在终端中使用：

```bash
dreamina login
```

无头登录流程通常会返回 `device_code`，之后可用：

```bash
dreamina login checklogin --device_code <device_code>
```

## 本地安装

从仓库根目录执行：

```bash
./scripts/install-local.sh
```

脚本会把当前仓库复制到默认插件目录：

```text
~/plugins/dreamina
```

然后通过你自己的 Codex marketplace 安装 / 更新插件：

```bash
codex plugin add dreamina@<your-marketplace-name>
```

`codex plugin add` 只能从已配置 marketplace 安装。首次安装请参考 `docs/installation.md` 中的 marketplace 配置说明。

## 在 Codex 中使用

安装后，在 Codex 插件页启用 Dreamina。常见提示词：

```text
查询我的 Dreamina 积分。
用 Dreamina 生成一张 16:9 的海边日落图片。
把这张参考图生成一段 5 秒视频。
查询 submit_id 为 xxx 的任务结果。
```

插件会在真正提交可能消耗积分的生成任务前提醒你。

## 项目结构

```text
.
├── .codex-plugin/plugin.json      # Codex 插件 manifest
├── agents/openai.yaml             # 插件级 Codex 展示信息
├── assets/                        # 插件图标
├── skills/dreamina-cli/           # Dreamina CLI skill 和封装脚本
├── docs/                          # 安装、开发、发布文档
├── scripts/                       # 本地安装和检查脚本
├── LICENSE                        # MIT 协议
└── README.md
```

## 开发

同步新版 `dreamina` CLI 时，请以 CLI 帮助为事实源：

```bash
dreamina -h
dreamina <subcommand> -h
```

然后更新：

- `skills/dreamina-cli/scripts/dreamina_wrapper.py` 中的命令定义
- `skills/dreamina-cli/references/commands.md`
- `skills/dreamina-cli/SKILL.md` 中的行为说明
- README / docs 中的用户文档

本地检查：

```bash
./scripts/check-sensitive.sh
./scripts/validate-local.sh
```

## 安全与隐私

本插件不保存 Dreamina 账号密码，不内置 token，不上传你的本地文件到本项目维护者。实际登录状态和生成任务由本地 `dreamina` CLI 及 Dreamina 服务处理。

不要把 `.env`、cookies、账号 token、生成结果中的私人素材、任务产物或本地会话目录提交到仓库。

## 许可证

本项目使用 [MIT License](LICENSE)。
