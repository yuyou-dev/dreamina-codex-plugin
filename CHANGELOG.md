# Changelog

## 0.1.2

- 同步 2026-06-26 版 `dreamina` CLI / v1.4.10 能力。
- `text2image`、`image2image` 新增 `generate_num` 参数封装，支持一次生成 1-10 张图片。
- 视频模型名同步为 Seedance 1.x / 2.x 命名；`image2video` 和 `frames2video` 保留常用旧模型名兼容映射。
- `seedance2.0_vip` 的视频分辨率支持更新为 `720p`、`1080p`、`4k`。
- `image_upscale` 文档同步 `2k/4k/8k` 分辨率及 VIP 权益说明。
- 补充创作 Session 管理文档同步。

## 0.1.1

- 同步 2026-06-22 版 `dreamina` CLI 帮助。
- 新增图片模型 `4.7` 支持：`text2image`、`image2image`。
- 新增视频模型 `seedance2.0mini` 支持：`text2video`、`image2video`、`frames2video`、`multimodal2video`。

## 0.1.0

- 初始开源版本。
- 支持 Dreamina / 即梦本地 CLI 的图片生成、视频生成、任务查询、积分查询和登录会话管理封装。
- 默认中文服务。
- 使用 MIT 协议发布。
