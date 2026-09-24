# Zellij

## zellij-smart-tabs (선택)

[YesYouKenSpace/zellij-smart-tabs](https://github.com/YesYouKenSpace/zellij-smart-tabs) 를 `~/.config/zellij/plugins/zellij-smart-tabs.wasm` 으로 두고, `config.kdl` 에서 `file://` 로 불러온다.
설치 방식은 `source`(기본, cargo 빌드)와 `release`(wasm 릴리즈 다운로드) 중 고를 수 있다.

### 켜기

1. `~/.config/chezmoi/chezmoi.toml` 의 `[data]` 에 다음을 넣는다 (또는 레포의 `.chezmoi.toml.tmpl` 을 반영해 동일 키를 둔다).

   ```toml
   [data]
   zellij_smart_tabs = true
   zellij_smart_tabs_install_mode = "source" # "source"(기본) | "release"
   zellij_smart_tabs_ref = "v0.1.0"
   # release 모드에서 비우면 기본 URL 사용
   # zellij_smart_tabs_wasm_url = "https://.../zellij-smart-tabs.wasm"
   ```

2. 설치 모드에 따라 요구사항이 다르다.
   - `source`(기본): **Rust** (`cargo`) + `rustup` + 타깃 `wasm32-wasip1` 필요
   - `release`: `curl` 로 prebuilt wasm 다운로드

3. `chezmoi apply` 를 실행한다.  
   - `dot_config/zellij/config.kdl.tmpl` 이 플러그인·키바인딩을 켠다.  
   - `run_onchange_after_01_build-zellij-smart-tabs.sh.tmpl` 이 모드에 따라 설치한다.
     - `source`: 저장소를 `~/.cache/chezmoi/zellij-smart-tabs` 에 두고 빌드 후 복사
     - `release`: wasm 파일을 release URL에서 받아 복사
     (스크립트 내용이 바뀌었을 때·첫 적용 시 등 [run_onchange](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run_a_script_when_the_file_changes) 규칙에 따라 실행)

4. Zellij 를 다시 시작한다.

### 끄기

`zellij_smart_tabs = false` 로 두거나 키를 제거하면(기본은 끔) 플러그인 블록과 부트 로드가 빠지고, 탭 모드 `r` 은 기본 이름 변경 동작만 한다.

### 업그레이드

`[data] zellij_smart_tabs_ref` 를 올린 뒤 `chezmoi apply` 한다.
- `source`: 다음 실행에서 해당 ref로 fetch/checkout 후 재빌드
- `release`: 기본 URL 또는 `zellij_smart_tabs_wasm_url` 에서 재다운로드

### source 모드 주의사항

`cargo build --release --target wasm32-wasip1` 처럼 **WASM 타깃**으로 빌드해야 한다.
호스트(예: `aarch64-apple-darwin`)만으로 빌드하면 `zellij_tile` 이 기대하는 WASM 호스트 심볼(`_host_run_plugin_command` 등)을 링크하지 못해 실패한다.

### 전제

- Zellij 0.44.0 이상  
- Nerd Font 권장(아이콘)  

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
