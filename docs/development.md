# 开发指南

## 原则

- `dreamina -h` 和 `dreamina <subcommand> -h` 是命令参数的事实源。
- 不要在 skill 中臆测模型、比例、时长、分辨率的支持范围；需要运行前先查对应子命令帮助。
- 生成任务可能消耗积分，面向用户时必须说清楚。
- 默认使用中文服务。

## 更新 CLI 适配

1. 记录当前 CLI 版本：

```bash
dreamina version
```

2. 查看总帮助和所有子命令帮助：

```bash
dreamina -h
dreamina text2image -h
dreamina image2image -h
dreamina image_upscale -h
dreamina text2video -h
dreamina image2video -h
dreamina frames2video -h
dreamina multiframe2video -h
dreamina multimodal2video -h
dreamina query_result -h
dreamina list_task -h
dreamina user_credit -h
dreamina login -h
dreamina login checklogin -h
dreamina relogin -h
dreamina logout -h
dreamina session -h
dreamina session create -h
dreamina session list -h
dreamina session search -h
dreamina session rename -h
dreamina session delete -h
```

3. 同步封装脚本和文档：

- `skills/dreamina-cli/scripts/dreamina_wrapper.py`
- `skills/dreamina-cli/scripts/*.py`
- `skills/dreamina-cli/references/commands.md`
- `skills/dreamina-cli/SKILL.md`
- `README.md`

4. 运行检查：

```bash
./scripts/validate-local.sh
./scripts/check-sensitive.sh
```

## 图标

`assets/logo.png` 和 `skills/dreamina-cli/assets/logo.png` 使用原始 Dreamina logo PNG。

`icon-small.png` 是从同一份 PNG 做像素缩放得到的 16x16 小图标；不要重绘 logo，不要改变形状和颜色。
