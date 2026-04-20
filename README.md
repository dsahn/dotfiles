# dotfiles
dotfiles for multiple platforms. maintained by chezmoi

## prerequiste

어쩔수없이 먼저 깔아야 하는것들

- rhel
  - zsh
  ```sh
  sudo dnf install zsh

  # in bash_profile
  export SHELL=`which zsh`
  exec `which zsh` -l
  ```

## 체크리스트

- [x] zshrc
  - [x] 회사전용 로직을 발라내고, 공통 세팅만 유지한다.
- [x] zsh-dependencies(fzf, powershell, ..)
- [x] ghostty settings
- [x] 패키지 매니저 설치(brew, cask) 및 설치스크립트 작성
- [x] karabiner 세팅(darwin)
- [x] vimrc(nvim)
  - [x] 개별 스트립트로 작성, 설치 여부 확인하기
  - [x] 최소 Lua 기반 nvim 설정 추가
  - [x] nvim + rust 환경 구축 문서화
  - 세부 과제는 [Neovim 개선 백로그](docs/nvim-backlog.md)에서 체크
  - [x] neotree: `filesystem`·`buffers`·`git_status`·`document_symbols` 네 소스, winbar 탭, `<`/`>` 순환
    - 토글: `<leader>e`(파일), `<leader>eb`(버퍼), `<leader>gE`(git), `<leader>eo`(심볼·LSP 필요)
- [ ] vscode common settings
- [x] aliases
- [x] tmux -> zellij in zshrc
- [x] yazi
  - 필요한 것들도 같이 깔아주지
- ? 회사환경/아닌환경 나눠서 뭔가 하려고했는디..

## 패키지 설치 관리 방식

- macOS 패키지 목록: `dot_Brewfile`
  - 설치는 `.chezmoiscripts/run_once_before_01_install-packages-darwin.sh.tmpl`에서
    `brew bundle --file <source Brewfile>`로 수행
- Linux 패키지 목록: `dot_config/nix/flake.nix`
  - 설치는 `.chezmoiscripts/run_once_before_01_install-packages-linux.sh.tmpl`에서
    `nix profile install <flake>#default`로 수행
- 공통 설치(oh-my-zsh, fzf, bun 등):
  `.chezmoiscripts/run_once_before_02_install-common.sh.tmpl`
- Zellij: `dot_config/zellij/config.kdl.tmpl`  
  - 선택적으로 [zellij-smart-tabs](https://github.com/YesYouKenSpace/zellij-smart-tabs) 설치·`file://` 로드 (`chezmoi` 데이터 `zellij_smart_tabs`)  
  - 설치 모드: `zellij_smart_tabs_install_mode = "source"`(기본, cargo 빌드) / `"release"`(wasm 릴리즈 다운로드)  
  - 자세한 절차: [docs/zellij.md](docs/zellij.md)

### 실행 예시

```sh
# 전체 적용 (OS별 패키지 + 공통 설치가 run_once 스크립트로 자동 실행)
chezmoi apply -v
```

```sh
# macOS: Brewfile만 수동 실행
brew bundle --file ~/.Brewfile
```

```sh
# Linux: flake 패키지만 수동 설치
nix profile install ~/.config/nix#default
```

## keybindings

- fzf 키바인딩
  - `Ctrl + R`: 명령어 히스토리 검색
  - `Ctrl + F`: 파일 선택해서 명령줄에 삽입 (기본 `Ctrl+T`에서 변경)
  - `Alt(option) + C`: 디렉터리 선택해서 이동
  - `**` + Tab: fzf 자동완성 트리거 (예: `nvim **<Tab>`)

- zsh vi 모드 (set -o vi)
  - `Esc`: normal 모드 진입
  - `v`: normal 모드에서 편집기로 명령어 편집
  - `Ctrl+X` `Ctrl+E`: insert/normal 모두에서 명령줄 전체를 `$VISUAL`/`$EDITOR`(nvim)로 편집

## zsh 설정 메모

### 시작 속도 최적화

- **fzf**: oh-my-zsh 플러그인 대신 `~/.fzf.zsh` 직접 source
- **mise/zoxide**: `eval "$(cmd)"` 대신 결과를 `~/.cache/`에 캐싱
  - 캐시 파일: `~/.cache/mise-init.zsh`, `~/.cache/zoxide-init.zsh`
  - mise/zoxide 바이너리가 업데이트되면 자동 갱신
- **compinit**: `ZSH_DISABLE_COMPFIX=true`로 보안 감사 오버헤드 절감
- **nvm**: lazy-load 적용 — `nvm`, `node`, `npm` 등 첫 사용 시에만 로드
  - 즉시 로드가 필요한 경우: `NVM_LAZY_LOAD=0 zsh` 또는 `~/.zshenv`에 설정
- **kubectl**: `kubectl` 있을 때만 OMZ 플러그인 로드. k8s 컨텍스트·네임스페이스 표시는 Powerlevel10k `kubecontext` 사용(oh-my-zsh `kube-ps1` 미사용)
- **측정**: `zprof`·벽시계로 시작 병목을 보려면 [zsh 시작 성능 측정 가이드](docs/zsh-startup-profiling.md) 참고

### k8s 환경 분리

회사 k8s 설정은 `~/.k8s-config.zsh`에 별도 관리 (chezmoi 비관리 대상).
템플릿에서 `source ~/.k8s-config.zsh 2>/dev/null` 으로 로드 (없으면 스킵).

## 자주쓸것들

- 초기 설정 : `chezmoi init`
- 관리대상 추가 : `chezmoi add ~/.zshrc`
- 수정 : `chezmoi edit ~/.zshrc`
- 변경한 것 반영 : `chezmoi apply -v`
- chezmoi workdir 이동 : `chezmoi cd` , 나가기 : `exit`
- 다른 장비에서 fetch ONLY : `chezmoi init $GITHUB_USERNAME` or  `chezmoi init git@github.com:$GITHUB_USERNAME/dotfiles.git`
  - 미리 확인 : `chezmoi diff`
  - 추가될 것 반영 : `chezmoi apply -v` / 반영 전 수정하기 : `chezmoi edit $FILE` / merge : `chezmoi merge $FILE`
  - 위의것 일괄 반영 : `chezmoi update -v`
  - 귀찮다면 일괄 적용 : `chezmoi init --apply $GITHUB_USERNAME` or `chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git`
  - 한큐에 apply : `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME`
    - apply 는 떼고 해도 되겠다.
- 데이터수정 : `chezmoi edit-config`
  - 템플릿 원본위치 : `~/.config/chezmoi/chezmoi.toml`
  - 장비별 값(회사/개인) 분리 권장: `[data]`의 `git_name`, `git_email`, `nvim_languages`
  - 예시
    ```toml
    [data]
      git_name = "회사이름"
      git_email = "회사메일@example.com"
      nvim_languages = ["typescript", "rust"]

    [edit]
      command = "nvim"
    ```
  - 반영 순서: `chezmoi edit-config` -> 저장 -> `chezmoi apply -v`

```
[edit]
    command = "nvim"

[merge]
    command = "nvim"
    args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
```

- 템플릿 관리대상(?) 으로 새로 추가: `chezmoi add --template ~/.config/git/config`
  - 관리대상을 템플릿으로 바꾸기: `chezmoi chattr +template ~/.zshrc`

### 참고문서

- https://pozafly.github.io/tools/manage-with-rm-rf-erased-setting-file-chezmoi/
- https://haril.dev/blog/2023/03/26/chezmoi-awesome-dotfile-manager

## neovim

Neovim 설정·언어 번들·Lazy·키맵·백로그는 [docs/nvim.md](docs/nvim.md)에 정리했다.

- 사이드바는 **neo-tree** 단일 패널에서 소스만 바꿔 쓴다(위 체크리스트·`dot_config/nvim/lua/plugins/core.lua`).
- `:` 명령 히스토리를 Telescope(fzf-native)로 고르기: `<leader>fc` (상세·나머지 키맵은 [docs/nvim.md](docs/nvim.md))
- [개요·관리 대상·기능·nvim_languages·Lazy·키맵](docs/nvim.md)
- [Git 워크플로우](docs/nvim-git-workflows.md)
- [LazyVim 스타일 플러그인 후보](docs/nvim-lazyvim-plugin-candidates.md)
- [Rust / TypeScript 매뉴얼](docs/nvim-language-manuals.md)
- [클립보드·외부 LLM CLI](docs/nvim-clipboard-llm.md)
- [개선 백로그](docs/nvim-backlog.md)
