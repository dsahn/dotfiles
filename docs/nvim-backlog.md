# Neovim 개선 백로그

lazy.nvim·LSP·Mason·conform·Telescope·Git·Treesitter·주요 UX 플러그인까지 갖춘 상태를 베이스로 두고, 아래를 순서대로 손보면 된다. 완료한 항목은 `[x]`로 바꾼다.

## 우선순위 높음 (문서·실사용과 맞닿음)

- [x] 언어별 확장: chezmoi `nvim_languages` + `lang_profiles.lua`로 treesitter / Mason LSP / conform 번들 (장비마다 선택)
- [ ] `nvim-lint` — ESLint 등, LSP·포맷과 보완
- [ ] Rust 심화: `rustaceanvim`, `crates.nvim` 검토 (기본 `rust_analyzer`·`rustfmt`는 번들에 포함)
- [ ] TypeScript: `vtsls` 등 프로젝트에 맞는 LSP로 `lang_profiles` 조정 검토

## 설정·동작

- [x] find in this directory 기능 세팅하기 (`<leader>fd` / `<leader>fs`, Telescope `search_dirs`)
- [x] 복사붙여넣기 동작을 vscode 와 유사하게 해주기
- [x] opencode/cursor CLI 연동 기본 키맵 추가하기
  - [x] claude code / codex / cursor agent 순으로 폴백 정렬하자
- [x] VSCode처럼 파일 트리와 변경(또는 diff) 트리 뷰를 전환해 쓰는 UX 검토 (`nvim-tree`, gitsigns, 별도 플러그인 등) — 결론·키맵은 [nvim-git-workflows.md](nvim-git-workflows.md#nvim-sidebar-git-views) 참고
- [ ] `lazy.lua`: `defaults.lazy = true` + 꼭 필요한 플러그인만 `lazy = false` 또는 `priority`
- [ ] `nvim-cmp`와 `nvim-autopairs`의 `<CR>` 연동 (겹침 시 줄바꿈·괄호 동작 정리)
- [ ] `cmp.setup.cmdline` — `:`, `/`, `?` 명령줄·검색 완성 (선택)
- [ ] 진단 UX: `]d` / `[d` 외에 `vim.diagnostic.open_float` 등 현재 줄 진단 매핑
- [ ] Telescope: 고정 커밋 해제 또는 태그 기준으로 주기적 갱신 전략 정하기

## 구조·유지보수

- [ ] lazy.nvim 사용하고 있다면 설치하고 있을 때 덮어쓸 지 물어보거나, 별도 세팅할 수 있도록 하기
- [ ] 플러그인 선언이 늘면 `lua/plugins/lang/*.lua` 등으로 분리 (`lang_profiles`는 데이터로 유지)
