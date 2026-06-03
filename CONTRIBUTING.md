# 贡献指南

欢迎提交 issue 和 PR。

## 提交前请确认

- 没有提交 `.env`、cookies、token、账号信息或私人任务产物。
- 如果更新 CLI 参数，已经对照 `dreamina -h` 和相关子命令 `-h`。
- README 和 `docs/` 中的用户说明已同步。
- 运行过：

```bash
./scripts/validate-local.sh
./scripts/check-sensitive.sh
```

## PR 建议说明

- 变更目的
- 涉及的 CLI 子命令
- 验证命令和结果
- 是否可能影响积分消耗或登录流程
