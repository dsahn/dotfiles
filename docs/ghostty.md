# Ghostty / cmux

Ghostty 단독 앱과 cmux가 **같은 터미널 설정**을 쓰도록 `~/.config/ghostty/config` 한곳에서 관리한다.
chezmoi 원본은 `dot_config/ghostty/config` 이다.

## 설정 파일 역할

| 경로 | chezmoi | 용도 |
|------|---------|------|
| `~/.config/ghostty/config` | 관리 | 폰트, 키바인드, 기본 `theme` 등 공유 터미널 설정 |
| `~/Library/Application Support/com.cmuxterm.app/config.ghostty` | **비관리** | `cmuxtheme` / `cmux themes set` 으로 바꾼 **장비별 cmux 테마** |
| `~/Library/Application Support/com.mitchellh.ghostty/config` | **비관리** | Ghostty macOS 레거시 경로 — 사용하지 않음 (남아 있으면 XDG 설정을 덮어씀) |
| `~/.config/cmux/cmux.json` | (별도) | cmux 앱 설정(단축키, 사이드바, 브라우저 등) |

## 테마 정책

- **chezmoi**: `dot_config/ghostty/config` 의 `theme` 등 공통 기본값만 관리한다.
- **장비 로컬 (cmux만)**: 셸에서 `cmuxtheme` 로 고른 테마는
  `~/Library/Application Support/com.cmuxterm.app/config.ghostty` 에만 기록되며,
  chezmoi로 동기화하지 않는다.
- Ghostty 단독 앱은 chezmoi config의 `theme` 을 그대로 쓴다.
- cmux는 config를 **병합**하므로, `config.ghostty` 에 테마가 있으면 chezmoi 기본 `theme` 보다 우선한다.

테마 오버라이드를 지우려면:

```sh
cmuxtheme clear
# 또는
cmux themes clear
```

## cmuxtheme

macOS zsh에서 `cmux-theme-fzf.zsh` 가 로드되면 `cmuxtheme` 함수를 쓸 수 있다.

```sh
cmuxtheme              # fzf로 light/dark 동시 적용
cmuxtheme --light      # light 테마만
cmuxtheme --dark       # dark 테마만
cmuxtheme clear        # cmux 테마 오버라이드 제거
```

설정 변경 후 cmux에 반영:

```sh
cmux reload-config
```

## macOS 마이그레이션 (1회)

Ghostty macOS 앱은 Application Support config가 XDG보다 **우선**한다.
예전에 `~/Library/Application Support/com.mitchellh.ghostty/config` 를 썼다면,
`chezmoi apply` 로 `~/.config/ghostty/config` 를 배포한 뒤 **수동으로** 레거시 파일을 지운다.

```sh
chezmoi apply -v
rm -f ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

레거시 파일이 남아 있으면 chezmoi XDG 설정이 무시되므로, 장비마다 한 번만 확인하면 된다.

- `macos-*` 옵션은 Ghostty macOS 전용이다. cmux는 알아서 무시한다.
- cmux UI 전용 옵션(`sidebar-font-size`, `surface-tab-bar-font-size` 등)도
  같은 `~/.config/ghostty/config` 에 넣을 수 있다.

## chezmoi

```sh
chezmoi edit ~/.config/ghostty/config
chezmoi apply -v
```

`.chezmoiignore` 에 cmux 장비 로컬 테마 파일(`config.ghostty`)과
레거시 Ghostty Application Support config를 넣어 drift를 막는다.
