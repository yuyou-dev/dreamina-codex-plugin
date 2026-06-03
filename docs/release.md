# 发布流程

## 本地发布前检查

```bash
./scripts/validate-local.sh
./scripts/check-sensitive.sh
git status --short
```

## 版本

Codex 本地插件开发可以使用 cachebuster 版本，例如：

```text
0.1.0+codex.20260603030224
```

正式 GitHub release 可以使用语义化版本，例如：

```text
v0.1.0
```

## 创建 tag

```bash
git tag v0.1.0
git push origin main --tags
```

## 发布说明建议

- 支持的 dreamina CLI 子命令
- 新增或变更的模型 / 参数
- 已知限制
- 安装方式
- 安全提醒：生成任务可能消耗积分
