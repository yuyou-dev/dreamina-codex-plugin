# 安装指南

## 1. 安装 Dreamina CLI

本插件依赖本机 `dreamina` 命令。请先按你的 CLI 发布渠道安装 `dreamina`，并确认它在 `PATH` 中：

```bash
dreamina -h
dreamina version
```

如果命令不存在，请先修复 CLI 安装或 shell `PATH`。

## 2. 安装本插件到 Codex 本地插件目录

在本仓库根目录执行：

```bash
./scripts/install-local.sh
```

默认安装目标：

```text
~/plugins/dreamina
```

你也可以指定目标目录：

```bash
DREAMINA_PLUGIN_TARGET=/path/to/plugins/dreamina ./scripts/install-local.sh
```

## 3. 安装到 Codex

如果你已经配置过自己的 Codex marketplace，并且其中有 `dreamina` 条目：

```bash
codex plugin add dreamina@<your-marketplace-name>
```

如果没有 marketplace 条目，可以先在你的 marketplace 文件中添加类似配置。下面示例假设 marketplace 文件位于 `~/.agents/plugins/marketplace.json`，插件安装在 `~/plugins/dreamina`：

```json
{
  "name": "local-plugins",
  "interface": {
    "displayName": "Local Plugins"
  },
  "plugins": [
    {
      "name": "dreamina",
      "source": {
        "source": "local",
        "path": "../../plugins/dreamina"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

不同机器上的相对路径可能不同。`source.path` 需要相对于 marketplace 文件所在目录。推荐让 Codex 的 plugin-creator 工具或你自己的 marketplace 管理流程来维护该文件。

添加后安装：

```bash
codex plugin add dreamina@local-plugins
```

## 4. 登录 Dreamina

```bash
dreamina login
```

或在 Codex 中让 Dreamina 插件执行登录流程。

## 5. 验证

```bash
dreamina user_credit
```

在 Codex 中可以说：

```text
用 Dreamina 查询我的积分。
```
