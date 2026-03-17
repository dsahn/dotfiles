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
- [ ] karabiner 세팅(darwin)
- [ ] vimrc(nvim)
  - [x] 개별 스트립트로 작성, 설치 여부 확인하기
  - [x] 최소 Lua 기반 nvim 설정 추가
  - [x] nvim + rust 환경 구축 문서화
- [ ] vscode common settings
- [x] aliases
- [x] tmux -> zellij in zshrc
- [x] yazi
  - 필요한 것들도 같이 깔아주지
- ? 회사환경/아닌환경 나눠서 뭔가 하려고했는디..

## keybindings

- fzf 키바인딩
  - Ctrl + R (^R): 명령어 히스토리 검색
  - Ctrl + T (^T): 파일 선택해서 명령줄에 삽입
  - Alt(option) + C (`^[c`): 디렉터리 선택해서 이동 ,(`^[` : escape)

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

### 관리 대상

- `dot_config/nvim/init.lua`
- `dot_config/nvim/lua/config/*.lua`
- `dot_config/nvim/lua/plugins/*.lua`
- `run_once_install-neovim-deps.sh.tmpl`

`chezmoi apply -v` 시 1회 설치 스크립트가 실행되고, 실제 설정은 `~/.config/nvim` 아래로 배치된다.

### 포함한 기본 기능

- `lazy.nvim` 기반 플러그인 로딩
- `kanagawa` colorscheme
- `telescope`, `oil`, `treesitter`
- `mason`, `lspconfig`, `nvim-cmp`
- 기본 formatter: `stylua`
- 기본 LSP: `lua_ls`

플러그인 설치는 수동 git clone 방식 대신 `lazy.nvim`에 전부 의존한다. 플러그인 목록과 설정은 dotfiles에서 관리하고, 실제 설치/업데이트/버전 고정은 Neovim 내부에서 처리한다.

### 초기 적용 순서

1. `chezmoi apply -v`
2. `nvim` 실행
3. 첫 실행에서 `lazy.nvim`이 자동 bootstrap
4. `:checkhealth` 로 상태 확인

### 플러그인 관리 방식

- 플러그인 선언 파일
  - `dot_config/nvim/lua/plugins/core.lua`
  - `dot_config/nvim/lua/plugins/lsp.lua`
  - `dot_config/nvim/lua/plugins/cmp.lua`

운영 원칙은 아래처럼 가져간다.

- 플러그인을 추가/삭제할 때는 `lua/plugins/*.lua`만 수정
- 실제 설치와 동기화는 `lazy.nvim`이 수행
- `lazy-lock.json`은 dotfiles에서 관리하지 않음(로컬 상태 파일)
- 플러그인 디렉터리를 `chezmoi`로 직접 vendoring 하지는 않음

### lazy.nvim 사용법

- 플러그인 관리 UI 열기
  ```vim
  :Lazy
  ```
- 플러그인 설치/동기화
  ```vim
  :Lazy sync
  ```
- 플러그인 업데이트
  ```vim
  :Lazy update
  ```
- 상태 확인
  ```vim
  :Lazy health
  ```

### lazy 운영 방식

새 장비에서의 흐름:

1. `chezmoi apply -v`
2. `nvim` 실행
3. `:Lazy sync`

플러그인을 추가하거나 버전을 올렸을 때의 흐름:

1. `lua/plugins/*.lua` 수정
2. `nvim` 실행
3. `:Lazy sync` 또는 `:Lazy update`

락파일은 각 장비의 로컬 상태로 두고, 필요 시 각 장비에서 동기화한다.

### 자주 쓰는 키

- `<leader>ff` : 파일 찾기
- `<leader>fg` : 문자열 검색
- `<leader>fb` : 버퍼 찾기
- `<leader>e` : 파일 탐색기
- `gd` : 정의로 이동
- `gr` : 참조 찾기
- `K` : hover 문서
- `<leader>ca` : 코드 액션
- `<leader>rn` : 이름 변경

### Rust 개발환경 매뉴얼

자동 설치까지는 넣지 않고, 아래 도구를 시스템에 준비해서 연결하는 방식으로 운영한다.

- 런타임
  - `rustup`
  - `cargo`
  - `rust-analyzer`
  - `rustfmt`
  - `clippy`
- 권장 설치 예시
  ```sh
  rustup toolchain install stable
  rustup component add rustfmt clippy
  rustup component add rust-analyzer
  ```
- Neovim 연동 포인트
  - `lspconfig`에 `rust_analyzer` 설정 추가
  - `conform.nvim`에 `rust = { "rustfmt" }` 추가
  - 필요하면 `crates.nvim`, `rustaceanvim` 도입 검토

### TypeScript 개발환경 매뉴얼

자동 설치까지는 넣지 않고, Node 생태계 도구를 먼저 준비한 뒤 Neovim에 연결한다.

- 런타임
  - `node`
  - `npm` 또는 `pnpm`
  - `typescript`
  - `typescript-language-server`
  - `prettier`
  - `eslint_d` 또는 `eslint`
- 권장 설치 예시
  ```sh
  npm install -g typescript typescript-language-server prettier eslint_d
  ```
- Neovim 연동 포인트
  - `lspconfig`에 `ts_ls` 또는 프로젝트 환경에 맞는 TypeScript LSP 설정 추가
  - `conform.nvim`에 `javascript`, `typescript`, `typescriptreact` formatter 추가
  - lint workflow가 중요하면 `nvim-lint` 추가 검토

### 확장 팁

- 회사/개인 환경 분리가 필요하면 `init.lua.tmpl` 또는 plugin 파일을 `.tmpl` 로 바꿔서 `chezmoi` 조건문을 넣는다
- 민감한 토큰은 `~/.config/nvim/.env` 같은 별도 파일로 분리하고, `chezmoi` encrypted/template data 기능을 사용한다
- 언어가 늘어나면 플러그인 파일을 `plugins/lang/*.lua` 식으로 더 쪼개는 편이 관리하기 쉽다
