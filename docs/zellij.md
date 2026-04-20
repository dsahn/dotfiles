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
