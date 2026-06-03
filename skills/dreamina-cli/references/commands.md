# Dreamina Wrapper Commands

## 1. Purpose

This reference describes the packaged Python wrapper scripts under `scripts/`. These wrappers are the preferred execution surface for the `dreamina-cli` skill.

They add:
- local path validation
- structured JSON success and failure payloads
- `--dry-run` support
- normalized argument names
- lightweight command-specific validation before invoking `dreamina`

When a flag combination is unclear, verify it with `dreamina <subcommand> -h`.

## 2. Discovery

Machine-readable inventory from the `dreamina-cli` skill directory:

```bash
python3 scripts/list_capabilities.py --format json
```

Readable inventory from the `dreamina-cli` skill directory:

```bash
python3 scripts/list_capabilities.py --format markdown
```

## 3. Wrapper catalog

### Image generation

- `text2image.py`
  - Required: `--prompt`
  - Optional: `--ratio`, `--resolution-type`, `--model-version`, `--session`, `--poll`
- `image2image.py`
  - Required: `--images`
  - Input count: `1-10`
  - Optional: `--prompt`, `--ratio`, `--resolution-type`, `--model-version`, `--session`, `--poll`
- `image_upscale.py`
  - Required: `--image`
  - Optional: `--resolution-type`, `--session`, `--poll`

### Video generation

- `text2video.py`
  - Required: `--prompt`
  - Optional: `--duration`, `--ratio`, `--video-resolution`, `--model-version`, `--session`, `--poll`
  - `seedance2.0_vip` supports `1080p`; other Seedance 2.0 variants currently use `720p`.
- `image2video.py`
  - Required: `--image`, `--prompt`
  - Optional: `--duration`, `--video-resolution`, `--model-version`, `--session`, `--poll`
  - Notes:
    - model aliases `3.0_fast`, `3.0_pro`, `3.5_pro` are normalized to CLI canonical values
    - advanced controls require `--model-version`
    - only `seedance2.0_vip` currently supports `1080p`; other models use `720p`
- `frames2video.py`
  - Required: `--first`, `--last`, `--prompt`
  - Optional: `--duration`, `--video-resolution`, `--model-version`, `--session`, `--poll`
  - only `seedance2.0_vip` currently supports `1080p`; other models use `720p`
- `multiframe2video.py`
  - Required: `--images`
  - Input count: `2-20`
  - Two-image mode:
    - use `--prompt`
    - optional `--duration` in seconds
    - duration is limited to `[0.5, 8]` and must be at least `2` seconds for exactly two images
  - Three-plus-image mode:
    - repeat `--transition-prompt`
    - optional repeated `--transition-duration`
    - each transition duration is limited to `[0.5, 8]`; total duration must be at least `2` seconds
  - Optional: `--session`, `--poll`
- `multimodal2video.py`
  - Dreamina's flagship "全能参考" mode, formerly `ref2video`
  - Required: at least one `--image` or `--video`
  - Optional: repeated `--image`, repeated `--video`, repeated `--audio`, `--prompt`, `--duration`, `--ratio`, `--video-resolution`, `--model-version`, `--session`, `--poll`
  - `seedance2.0_vip` supports `1080p`; other Seedance 2.0 variants currently use `720p`.

### Query, list, and account

- `query_result.py`
  - Required: `--submit-id`
  - Optional: `--download-dir`
- `list_task.py`
  - Optional: `--submit-id`, `--gen-status`, `--gen-task-type`, `--limit`, `--offset`
- `user_credit.py`
  - No task-specific parameters

### Session and environment

- `login.py`
  - Optional: `--headless`
  - Uses OAuth Device Flow. `--headless` prints `verification_uri`, `user_code`, and `device_code`.
- `checklogin.py`
  - Required: `--device-code`
  - Optional: `--poll`
  - Completes or checks a prior headless OAuth Device Flow started by `login.py --headless` or `relogin.py --headless`.
- `logout.py`
  - No task-specific parameters
- `relogin.py`
  - Optional: `--headless`
  - Uses OAuth Device Flow. Complete headless authorization with `dreamina login checklogin --device_code=<device_code>`.
- `version.py`
  - No task-specific parameters

### Raw CLI-only session management

Dreamina also exposes `dreamina session` directly. These commands are currently raw CLI-only, not Python wrapper scripts:

- `dreamina session create [name]`
  - Create a session. Omit `name` to let the backend auto-name it.
  - Names must be 1-50 characters after trimming spaces.
- `dreamina session list [-n|--max-count N]`
  - List recent sessions. Default is 30; user-specified values are capped at 100.
  - Alias: `dreamina session ls`.
- `dreamina session search <name>`
  - Search recent sessions by case-sensitive name substring.
  - Alias: `dreamina session find <name>`.
- `dreamina session rename <session_id> <new_name>`
  - Rename a session. Session `0` cannot be renamed.
  - Alias: `dreamina session update <session_id> <new_name>`.
- `dreamina session delete <session_id>`
  - Delete a session. Session `0` cannot be deleted; history is moved back to the default session.
  - Alias: `dreamina session rm <session_id>`.

## 4. Argument naming

The wrappers accept hyphen-style names and convert them to the CLI's required flag names.

Examples:
- `--model-version` becomes `--model_version`
- `--resolution-type` becomes `--resolution_type`
- `--video-resolution` becomes `--video_resolution`
- `--submit-id` becomes `--submit_id`

The underscore forms are also accepted when needed.

## 5. Common patterns

Inspect the generated CLI command without running it:

```bash
python3 scripts/text2image.py \
  --prompt "clean silver ring product shot" \
  --ratio 1:1 \
  --resolution-type 2k \
  --dry-run
```

Submit a task and let Dreamina poll briefly:

```bash
python3 scripts/text2video.py \
  --prompt "camera pushes toward a necklace on a gray stage" \
  --duration 5 \
  --poll 60
```

Check a prior headless OAuth Device Flow:

```bash
python3 scripts/checklogin.py --device-code <device_code> --poll 30
```

List successful tasks:

```bash
python3 scripts/list_task.py --gen-status success --limit 20
```

## 6. Return contract

Success payload:

```json
{
  "ok": true,
  "command": "text2image",
  "cli_args": ["dreamina", "text2image", "..."],
  "data": {}
}
```

Failure payload:

```json
{
  "ok": false,
  "command": "text2image",
  "cli_args": ["dreamina", "text2image", "..."],
  "error": "normalized message",
  "details": ["detail 1", "detail 2"]
}
```

For generation wrappers:
- `ok: true` means the wrapper saw a valid async submit payload
- `submit_id` is available in `data.submit_id`
- `gen_status=fail` is converted into `ok: false`

## 7. Current validation scope

The wrappers currently validate:
- required fields
- file path existence
- known ratio/model/resolution choices
- command-specific range and combination rules
- multiframe transition counts
- headless OAuth checklogin required fields
- multimodal input count limits

The wrappers do not currently inspect media duration or image dimensions. Dreamina CLI remains the final enforcer for those deeper server-side rules.
