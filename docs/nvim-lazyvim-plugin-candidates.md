# LazyVim 플러그인 참고 목록

LazyVim 사용 중 유용했던 플러그인들. 필요 시 `lua/plugins/`에 추가.

## UI / 편의

- [x] [`folke/noice.nvim`](https://github.com/folke/noice.nvim) — cmdline, 메시지, 팝업 UI를 통합 개선
  - 빠른 사용 예시
    - `:Noice` : noice 상태/명령 진입점
    - `:Noice history` : 최근 메시지 히스토리 확인
    - `:Noice dismiss` : 현재 떠 있는 메시지/팝업 닫기
- [`akinsho/bufferline.nvim`](https://github.com/akinsho/bufferline.nvim) — 버퍼를 탭처럼 표시
- [x] [`lukas-reineke/indent-blankline.nvim`](https://github.com/lukas-reineke/indent-blankline.nvim) — 들여쓰기 가이드 라인
  - 빠른 사용 예시
    - 코드 블록 중첩 깊이를 세로 가이드 라인으로 즉시 확인
    - 커서를 블록 안에 두면 현재 스코프 가이드가 강조되어 범위 파악이 쉬움
- [`nvimdev/dashboard-nvim`](https://github.com/nvimdev/dashboard-nvim) — 시작 화면
- [`norcalli/nvim-colorizer.lua`](https://github.com/norcalli/nvim-colorizer.lua) — hex 색상 코드 미리보기

## 탐색 / 이동

- [`folke/flash.nvim`](https://github.com/folke/flash.nvim) — `s`키로 화면 내 빠른 점프 (easymotion 대체)
- [`stevearc/oil.nvim`](https://github.com/stevearc/oil.nvim) — 파일시스템을 버퍼처럼 편집 (nvim-tree 대안)

## 진단 / Git

- [`folke/trouble.nvim`](https://github.com/folke/trouble.nvim) — LSP 진단/참조/quickfix 목록 UI
- [`folke/todo-comments.nvim`](https://github.com/folke/todo-comments.nvim) — TODO/FIXME 하이라이팅 + telescope 연동
- [`kdheepak/lazygit.nvim`](https://github.com/kdheepak/lazygit.nvim) — nvim 안에서 lazygit 실행 (`brew install lazygit` 필요)

## 편집

- [x] [`kylechui/nvim-surround`](https://github.com/kylechui/nvim-surround) — 괄호/따옴표 감싸기/변경/제거 (`cs"'`, `ds)` 등)
  - 빠른 사용 예시
    - `ysiw)` : 단어를 괄호로 감싸기
    - `cs"'` : 따옴표 변경
    - `ds)` : 괄호 제거
  - 매핑 확인: `:verbose nmap ys`
- [`echasnovski/mini.ai`](https://github.com/echasnovski/mini.ai) — `a`/`i` 텍스트 오브젝트 확장 (함수, 클래스 단위 선택)
- [`mfussenegger/nvim-lint`](https://github.com/mfussenegger/nvim-lint) — 언어별 linter 연동 (eslint, shellcheck 등)

## 언어 지원 (LSP 추가)

[nvim.md](nvim.md)의 `nvim_languages` 표에 있는 서버는 해당 키를 넣으면 Mason `ensure_installed`와 `vim.lsp.enable()`에 자동 반영된다. 새 언어를 레포에 추가하려면 `lang_profiles.lua`에 treesitter / `mason` / `conform` / `enable_lsp` 분기를 한 곳에만 추가하면 된다.

플러그인 설치는 수동 git clone 방식 대신 `lazy.nvim`에 전부 의존한다. 플러그인 목록과 설정은 dotfiles에서 관리하고, 실제 설치/업데이트/버전 고정은 Neovim 내부에서 처리한다.
