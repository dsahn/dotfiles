# Zellij

## 키바인딩

`dot_config/zellij/config.kdl.tmpl` 은 `clear-defaults` 없이 **zellij 기본 키맵을 그대로 쓰고, 바꿀 것만 덮어쓴다.**
zellij 를 업그레이드하면 새 기본 키가 자동으로 따라온다.

- 기본 키맵 확인: `zellij setup --dump-config`
- 모드별 블록(`scroll { ... }`)에 같은 키를 다시 `bind` 하면 기본값을 덮어쓴다.
- 기본 키를 없애려면 해당 모드 안에서 `unbind "키"` 를 쓴다.

덮어쓰는 것:

| 모드 | 키 | 동작 | 조건 |
|---|---|---|---|
| scroll | `Alt h/j/k/l`, `Alt ←↓↑→` | 패인 이동 후 normal 로 나감 (기본은 scroll 모드 유지) | 항상 |
| locked 외 전부 | `Ctrl y` | harpoon 열기 | `zellij_harpoon` |
| locked 외 전부 | `Alt /` | 키바인딩 검색(zj-which-key browser) 열기 | `zellij_which_key` |

## harpoon (선택)

[Nacho114/harpoon](https://github.com/Nacho114/harpoon) 은 자주 쓰는 패인을 목록에 등록해 두고 바로 이동하는 플러그인이다 (nvim harpoon 의 zellij 판).
`~/.config/zellij/plugins/harpoon.wasm` 으로 두고 `config.kdl` 키바인딩에서 `file://` 로 불러온다.
GitHub release 가 없어 **소스 빌드만** 지원한다.

### 켜기

1. `~/.config/chezmoi/chezmoi.toml` 의 `[data]` 에 다음을 넣는다.

   ```toml
   [data]
   zellij_harpoon = true
   # 검토한 커밋 SHA 로 고정
   zellij_harpoon_ref = "7553290e22516c230e598e4fa81d91b1714a0a08"
   ```

2. **Rust** (`cargo`) + `rustup` + `git` 이 필요하다. 타깃 `wasm32-wasip1` 은 스크립트가 추가한다.

3. `chezmoi apply` 를 실행한다.
   - `dot_config/zellij/config.kdl.tmpl` 이 `Ctrl y` 키바인딩을 켠다.
   - `run_onchange_after_02_build-zellij-harpoon.sh.tmpl` 이 `~/.cache/chezmoi/zellij-harpoon` 에 해당 커밋을 받아 `cargo build --release --locked` 후 복사한다.

4. 처음 `Ctrl y` 를 누르면 권한 요청(`ReadApplicationState`, `ChangeApplicationState`, `RunCommands`)이 뜬다. `y` 로 승인하면 이후엔 묻지 않는다.

### 사용법

어느 모드에서든(`locked` 제외) `Ctrl y` 로 floating 창을 연다.

| 키 | 동작 |
|---|---|
| `a` | 열기 직전 포커스였던 패인을 목록에 추가 (추가 후 바로 닫힘) |
| `A` | 모든 탭의 터미널 패인을 전부 추가 |
| `d` | 선택 항목 삭제 |
| `j` / `k`, `↑` / `↓` | 항목 이동 |
| `Enter` / `l` | 선택한 패인으로 이동 |
| `Esc` / `c` | 닫기 |

- 닫힌 패인은 목록에서 자동으로 빠지고, 탭·패인 이름 변경은 목록에 반영된다.
- 목록은 세션별로 `~/.local/share/zellij-harpoon/<세션명>.json` 에 "탭 이름 + 패인 제목"으로 저장된다. 세션 복원 시 같은 제목의 패인이 여러 개면 다른 패인에 연결될 수 있다.

### 주의사항

- **floating 패인이 같이 뜬다**: floating 레이어는 탭 단위로 한꺼번에 보이고 숨는다. 그 탭에 숨겨둔 floating 패인(`Alt f` 로 만든 것 등)이 있으면 harpoon 을 열 때 함께 보이고, harpoon 을 닫아도 남는다. harpoon 이 패인을 만드는 것은 아니다.
- **세션 이름**: 저장 경로가 따옴표 없이 `sh -c` 문자열에 들어간다. 세션 이름에 공백이나 `;`, `$(...)` 같은 셸 문자를 쓰지 않는다.
- `RunCommands` 권한은 저장/로드(`cat`, `mkdir`, `printf`)에만 쓰인다 (커밋 `7553290` 기준 검토). 네트워크 접근과 `build.rs` 는 없다.

### 업그레이드

upstream 변경분(`src/`)을 검토한 뒤 `[data] zellij_harpoon_ref` 를 새 커밋 SHA 로 바꾸고 `chezmoi apply` 한다. 스크립트 내용이 바뀌므로 다음 적용에서 재빌드된다.

### 끄기

`zellij_harpoon = false` 로 두면 `Ctrl y` 키바인딩이 빠진다. 이미 설치된 `harpoon.wasm` 은 남으니 필요하면 직접 지운다.

## zj-which-key: 키바인딩 검색 (선택)

[johnae/zj-which-key](https://github.com/johnae/zj-which-key) 의 **browser** 로, 모든 모드의 키바인딩을 한 화면에서 fuzzy 검색한다.
"detach 가 뭐였지?" 처럼 키가 기억나지 않을 때 `Alt /` → 단어 입력으로 바로 찾는다. 따로 검색 모드에 들어갈 필요 없이 **열자마자 입력하면 걸러진다.**
내 `config.kdl` 의 실제 키바인딩(덮어쓴 키 포함)을 읽어 보여준다. GitHub release 가 없어 **소스 빌드만** 지원한다.

### 켜기

1. `~/.config/chezmoi/chezmoi.toml` 의 `[data]` 에 다음을 넣는다.

   ```toml
   [data]
   zellij_which_key = true
   # 검토한 커밋 SHA 로 고정 (v0.2.0)
   zellij_which_key_ref = "48f7d3fe8cdf360b10d1b5ce3038d593935779eb"
   ```

2. **Rust** (`cargo`) + `rustup` + `git` 이 필요하다. 타깃 `wasm32-wasip1` 은 스크립트가 추가한다.

3. `chezmoi apply` 를 실행한다.
   - `dot_config/zellij/config.kdl.tmpl` 이 `Alt /` 키바인딩을 켠다.
   - `run_onchange_after_03_build-zellij-which-key.sh.tmpl` 이 `~/.cache/chezmoi/zellij-which-key` 에 해당 커밋을 받아 빌드·복사하고, **권한을 zellij 캐시에 미리 등록한다** (아래 권한 참고).

### 사용법

어느 모드에서든(`locked` 제외) `Alt /` 로 floating 창을 연다.

| 키 | 동작 |
|---|---|
| 글자 입력 | 바로 fuzzy 검색 (예: `detach`, `split`, `float`) |
| `Backspace` / `Ctrl u` | 한 글자 / 검색어 전체 지우기 |
| `↑` `↓`, `Ctrl p` `Ctrl n` | 스크롤 |
| `Esc` / `Enter` | 닫기 |

- 결과는 모드별(`Pane`, `Tab`, `Session` …)로 묶여 나오고, 어느 모드에서든 쓰는 키는 `Global` 절에 모인다.
- **조회 전용**이다. 여기서 키를 실행할 수는 없으니, 찾은 뒤 닫고 그 키를 누른다.

### 권한

플러그인이 권한 요청 창의 키 입력을 받지 못해서(README 의 zellij 제약), 스크립트가 zellij 권한 캐시에 항목을 미리 추가한다. 이미 있으면 건드리지 않는다.

- macOS: `~/Library/Caches/org.Zellij-Contributors.Zellij/permissions.kdl`
- Linux: `${XDG_CACHE_HOME:-~/.cache}/zellij/permissions.kdl`
- 등록 권한: `ReadApplicationState`, `ChangeApplicationState` (browser 에 필요한 것만). `RunCommands`·네트워크·파일 접근은 쓰지 않는다 (커밋 `48f7d3f` 기준 검토).

### 선택: which-key 식 popup

모드에 들어가(`Ctrl p` 등) 잠깐 멈추면 모서리에 그 모드의 키를 띄우는 popup 도 있다. 지금은 **끄고 browser 만 쓴다.** 켜려면 `config.kdl.tmpl` 에 아래를 추가하고, 권한 캐시 항목에 `MessageAndLaunchOtherPlugins` 를 더한다.

```kdl
load_plugins {
    "file://<HOME>/.config/zellij/plugins/zj_which_key.wasm" {
        auto_show "true"
        delay_secs "0.4"
        position "bottom-right"   // 또는 "bottom-left"
        max_height_pct "40"
    }
}
```

### 업그레이드

upstream 변경분(`src/`)을 검토한 뒤 `[data] zellij_which_key_ref` 를 새 커밋 SHA 로 바꾸고 `chezmoi apply` 한다. wasm 경로가 같아서 권한 항목은 그대로 쓴다.

### 끄기

`zellij_which_key = false` 로 두면 `Alt /` 키바인딩이 빠진다. 이미 설치된 `zj_which_key.wasm`, 빌드 캐시(`~/.cache/chezmoi/zellij-which-key`), 권한 캐시 항목은 남으니 필요하면 직접 지운다.

## 참고: zellij-smart-tabs (chezmoi 연동 제거됨)

[YesYouKenSpace/zellij-smart-tabs](https://github.com/YesYouKenSpace/zellij-smart-tabs) 는 탭 이름을 자동으로 붙여주는 플러그인이다.
자잘한 버그(예: 탭 모드 `r` 로 직접 바꾼 이름이 자동 이름으로 되돌아감) 때문에 chezmoi 연동을 뺐다.
다시 쓰려면 아래를 수동으로 적용한다. 마지막으로 쓰던 버전은 `v0.1.0` 이다.

### 설치

```sh
rustup target add wasm32-wasip1
git clone --depth 1 --branch v0.1.0 https://github.com/YesYouKenSpace/zellij-smart-tabs.git
cd zellij-smart-tabs
cargo build --release --target wasm32-wasip1   # 호스트 타깃으로 빌드하면 링크 실패
cp target/wasm32-wasip1/release/zellij-smart-tabs.wasm ~/.config/zellij/plugins/
```

release 가 있는 버전이면 `https://github.com/YesYouKenSpace/zellij-smart-tabs/releases/download/<ref>/zellij-smart-tabs.wasm` 을 받아도 된다.

### config.kdl

`dot_config/zellij/config.kdl.tmpl` 에 넣는다 (`<HOME>` 은 `{{ .chezmoi.homeDir }}` 로).

```kdl
keybinds {
    // 직접 이름을 바꾸면 수동 이름으로 고정, 취소하면 자동 이름으로 되돌린다.
    tab {
        bind "r" {
            MessagePlugin "smart-tabs" {
                name "set_focused_to_manual"
            }
            SwitchToMode "renametab"
            TabNameInput 0
        }
    }
    renametab {
        bind "esc" {
            UndoRenameTab
            SwitchToMode "tab"
            MessagePlugin "smart-tabs" {
                name "set_focused_to_managed"
            }
        }
    }
}

plugins {
    smart-tabs location="file://<HOME>/.config/zellij/plugins/zellij-smart-tabs.wasm"
}

load_plugins {
    smart-tabs
}
```

Zellij 0.44.0 이상, Nerd Font 권장(아이콘). 적용 후 zellij 를 다시 시작한다.
처음 로드할 때 권한 요청(`ReadApplicationState`, `ChangeApplicationState`, `RunCommands`)이 다시 뜬다.

### chezmoi 연동으로 되돌리기

예전 자동화(data 플래그로 켜고 끄기, `source`/`release` 빌드 스크립트)는 커밋 `5e9cb18` 에서 지웠다. 그대로 되살리려면:

```sh
chezmoi cd
git revert 5e9cb18    # 템플릿 분기·빌드 스크립트·.chezmoi.toml.tmpl 키 복원
```

그 뒤 `~/.config/chezmoi/chezmoi.toml` 의 `[data]` 에 키를 넣고 `chezmoi apply` 한다.

```toml
zellij_smart_tabs = true
zellij_smart_tabs_install_mode = "source" # "source"(cargo 빌드) | "release"(wasm 다운로드)
zellij_smart_tabs_ref = "v0.1.0"
zellij_smart_tabs_wasm_url = ""           # release 모드에서 비우면 기본 URL
```

템플릿이 그 뒤로 바뀌어 revert 가 충돌하면 `git show 5e9cb18^:<경로>` 로 지우기 전 내용을 보고 직접 옮긴다.
