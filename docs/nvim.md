# Neovim

chezmoi로 배포하는 Neovim 설정의 구조·운영·언어 번들을 정리한다. 아래 **관련 문서**는 모두 이 가이드의 하위 문서로 두고, 필요한 주제만 골라 읽으면 된다.

## 관련 문서

- [Git 워크플로우 (neogit / diffview / gitsigns)](nvim-git-workflows.md)
- [LazyVim 스타일 플러그인 후보](nvim-lazyvim-plugin-candidates.md)
- [Rust / TypeScript 수동 설치 매뉴얼](nvim-language-manuals.md)
- [클립보드·외부 LLM CLI](nvim-clipboard-llm.md)
- [개선 백로그](nvim-backlog.md)

## 관리 대상

- `dot_config/nvim/init.lua`
- `dot_config/nvim/lua/config/*.lua` (공용 Lua 설정)
- `dot_config/nvim/lua/config/lang_profiles.lua` — 선택 언어별 treesitter / Mason LSP / conform 매핑
- `dot_config/nvim/lua/config/machine.lua.tmpl` — chezmoi가 `~/.config/nvim/lua/config/machine.lua`로 생성
- `dot_config/nvim/lua/plugins/*.lua`
- `.chezmoi.toml.tmpl` — `[data] nvim_languages` 기본값(빈 목록). 기존 `chezmoi.toml`만 쓰는 경우 해당 파일에 동일 키를 수동 추가해도 된다
- `run_once_install-neovim-deps.sh.tmpl`

`chezmoi apply -v` 시 1회 설치 스크립트가 실행되고, 실제 설정은 `~/.config/nvim` 아래로 배치된다.

## 포함한 기본 기능

- `lazy.nvim` 기반 플러그인 로딩
- `kanagawa` colorscheme
- `telescope` + `telescope-fzf-native` (파일/문자열 검색)
  - 기본: `<leader>ff` / `<leader>fg`
  - 숨김 포함: `<leader>fF` / `<leader>fG` (`.git/` 제외)
  - 현재 디렉토리 기준: `<leader>fd` / `<leader>fs`
  - 현재 디렉토리 + 숨김 포함: `<leader>fD` / `<leader>fS` (`.git/` 제외)
  - `ff` / `fg` / `fd` / `fs` 실행 후 Telescope 창 안에서 `<M-h>`로 숨김 검색 토글 가능
- `neo-tree.nvim` (사이드바: 파일 트리 + git 상태 트리, `filesystem` / `git_status`)
- `treesitter` (문법 하이라이팅/들여쓰기)
- `which-key` (리더키 힌트 팝업)
- `lualine` (상태바)
- `gitsigns` (git 변경 표시, hunk 이동/stage/blame)
- `diffview.nvim` (diff 뷰어, 파일 히스토리)
- `neogit` (magit 스타일 git UI)
  - Git 키맵과 추천 워크플로우: [nvim-git-workflows.md](nvim-git-workflows.md)
- `mason` + `lspconfig` + `nvim-cmp` (LSP, 자동완성)
- `conform.nvim` (저장 시 자동 포맷)
- `LuaSnip` + `friendly-snippets` (스니펫)
- `Comment.nvim`, `nvim-autopairs`
- 기본 formatter: `stylua`
- 기본 LSP: `lua_ls`
- 선택 언어: chezmoi `[data] nvim_languages`로 번들 켜기 (아래 절 참고)

## 머신별 선택 언어 (`nvim_languages`)

장비마다 스택이 다를 수 있으므로, **Lua + 공용 편집 기능은 항상** 켜 두고 **추가 언어만** chezmoi 데이터로 켠다.

1. `~/.config/chezmoi/chezmoi.toml` (또는 이 레포의 `.chezmoi.toml.tmpl`을 쓰는 경우 그 템플릿)에 다음을 넣는다.

   ```toml
   [data]
   nvim_languages = ["rust", "typescript"]
   ```

2. `chezmoi apply -v` 후 `nvim`에서 `:Lazy sync`, 필요 시 `:Mason`으로 LSP/도구 설치를 확인한다.

**허용 값** (이름은 `lang_profiles.lua`와 동일해야 한다): `rust`, `typescript`, `python`, `go`, `clang` (C/C++). 목록이 비어 있으면 예전과 같이 `lua_ls` + stylua + 공용 treesitter만 사용한다.

**각 번들이 켜는 것(요약)**

| 키 | Treesitter(추가) | Mason LSP | conform (저장 시 포맷) |
|----|------------------|-----------|-------------------------|
| `rust` | `rust` | `rust_analyzer` | `rustfmt` |
| `typescript` | `javascript`, `typescript`, `tsx` | `ts_ls` | `prettier` (js/ts/jsx/tsx) |
| `python` | `python` | `pyright` | `black` |
| `go` | `go` | `gopls` | `gofmt` |
| `clang` | `c`, `cpp` | `clangd` | `clang_format` |

포맷터·언어 서버는 **PATH 또는 Mason**에 있어야 한다. 도구 설치는 [언어 매뉴얼](nvim-language-manuals.md)을 따른다.

추가 플러그인 아이디어는 [nvim-lazyvim-plugin-candidates.md](nvim-lazyvim-plugin-candidates.md)를 본다.

## 초기 적용 순서

1. `chezmoi apply -v`
2. `nvim` 실행
3. 첫 실행에서 `lazy.nvim`이 자동 bootstrap
4. `:checkhealth` 로 상태 확인

## 플러그인 관리 방식

- 플러그인 선언 파일
  - `dot_config/nvim/lua/plugins/core.lua`
  - `dot_config/nvim/lua/plugins/lsp.lua`
  - `dot_config/nvim/lua/plugins/cmp.lua`

운영 원칙은 아래처럼 가져간다.

- 플러그인을 추가/삭제할 때는 `lua/plugins/*.lua`만 수정
- 실제 설치와 동기화는 `lazy.nvim`이 수행
- `lazy-lock.json`은 dotfiles에서 관리하지 않음(로컬 상태 파일)
- 플러그인 디렉터리를 `chezmoi`로 직접 vendoring 하지는 않음

## lazy.nvim 사용법

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

## lazy 운영 방식

새 장비에서의 흐름:

1. `chezmoi apply -v`
2. `nvim` 실행
3. `:Lazy sync`

플러그인을 추가하거나 버전을 올렸을 때의 흐름:

1. `lua/plugins/*.lua` 수정
2. `nvim` 실행
3. `:Lazy sync` 또는 `:Lazy update`

락파일은 각 장비의 로컬 상태로 두고, 필요 시 각 장비에서 동기화한다.

## 자주 쓰는 키

**파일 / 탐색**

- `<leader>e` : 파일 트리 토글 (neo-tree `filesystem`)
- `<leader>gE` : git 변경 트리 토글 (neo-tree `git_status`). 상세는 [nvim-git-workflows.md#nvim-sidebar-git-views](nvim-git-workflows.md#nvim-sidebar-git-views)
- `<leader>ff` : 파일 찾기
- `<leader>fd` : 현재 파일이 있는 폴더만 대상으로 파일 찾기
- `<leader>fg` : 문자열 검색 (워크스페이스)
- `<leader>fs` : 현재 파일이 있는 폴더만 대상으로 문자열 검색
- `<leader>fb` : 버퍼 찾기
- `<leader>fk` : 키맵 찾기

**LSP**

- `gd` : 정의로 이동
- `gr` : 참조 찾기
- `K` : hover 문서
- `<leader>ca` : 코드 액션
- `<leader>rn` : 이름 변경

**Git**

- 상세 키맵과 제안 목록은 [nvim-git-workflows.md](nvim-git-workflows.md) 참고
- `<leader>gS` : 변경 파일 목록 (Telescope `git_status`). 사이드바·diff와의 역할 분담은 [워크플로 문서의 해당 절](nvim-git-workflows.md#nvim-sidebar-git-views) 참고

`which-key`를 설치해둬서 `<leader>`를 누르면 사용 가능한 키 조합 힌트를 팝업으로 확인할 수 있다.

## 확장 팁

- 언어별 온오프는 우선 `[data] nvim_languages`와 `lang_profiles.lua`로 처리한다. 더 세분화하면 `machine.lua.tmpl`에 다른 chezmoi 변수를 넘기도록 확장할 수 있다
- 회사/개인 환경 분리가 필요하면 `init.lua.tmpl` 또는 plugin 파일을 `.tmpl` 로 바꿔서 `chezmoi` 조건문을 넣는다
- 민감한 토큰은 `~/.config/nvim/.env` 같은 별도 파일로 분리하고, `chezmoi` encrypted/template data 기능을 사용한다
- 플러그인 선언이 커지면 `lua/plugins/lang/*.lua` 식으로 쪼개는 편이 관리하기 쉽다 (`lang_profiles`는 설정 데이터로 유지하는 편이 단순하다)
