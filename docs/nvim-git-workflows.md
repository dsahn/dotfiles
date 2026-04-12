# Neovim Git Workflows

[nvim.md](nvim.md) 하위 문서. Neovim 안에서 Git 작업은 `gitsigns` + `diffview.nvim` + `neogit` 조합으로 사용한다.

## 현재 적용된 키맵

| 키맵 | 동작 | 출처 |
|---|---|---|
| `<leader>gg` | Neogit status | neogit |
| `<leader>gc` | Neogit commit popup | neogit |
| `<leader>gB` | Neogit branch popup | neogit |
| `<leader>gP` | Neogit push popup | neogit |
| `<leader>gl` | Neogit log popup | neogit |
| `<leader>gd` | Diffview 열기 | diffview |
| `<leader>gh` | 현재 파일 history | diffview |
| `<leader>gH` | 저장소 history | diffview |
| `<leader>gx` | Diffview 닫기 | diffview |
| `<leader>gp` | hunk 미리보기 | gitsigns |
| `<leader>gb` | 현재 줄 blame | gitsigns |
| `<leader>gs` | hunk stage | gitsigns |
| `<leader>gr` | hunk reset | gitsigns |
| `<leader>gS` | 변경 파일 목록 (Telescope) | telescope |
| `]h` | 다음 hunk | gitsigns |
| `[h` | 이전 hunk | gitsigns |

<span id="nvim-sidebar-git-views"></span>

## 사이드바: 파일 트리 vs 변경(또는 diff) 뷰

VSCode의 **Explorer**와 **Source Control**을 한 창에서 소스만 바꿔 켜는 패턴(`neo-tree`의 `filesystem` / `git_status` 전환 등)에 가장 가깝게 가려면 플러그인 교체가 필요하다. 현재 스택(`nvim-tree` + `gitsigns` + `diffview`)에서는 아래처럼 역할을 나누는 편이 단순하다.

| 목적 | 추천 진입 | 설명 |
|------|-----------|------|
| 워크스페이스 전체 파일 트리 | `<leader>e` | `nvim-tree` 사이드바 |
| **변경 파일만** 트리(고정 패널) | `<leader>gd` | `diffview` 왼쪽 `file_panel`(트리 스타일). `<leader>gx`로 닫기 |
| 변경 파일 빠른 선택(플로팅) | `<leader>gS` | `Telescope git_status` — 파일 열기·스테이징 등은 Telescope 기본 동작 |
| 인라인 하이라이트·헝크 작업 | `gitsigns` | 사이드바와 무관하게 버퍼에서 처리 |

`gitsigns`는 gutter·blame·hunk 단위 동작에 두고, “변경 목록을 트리로 훑기”는 **diffview 패널** 또는 **Telescope**로 보완하는 구성이다. 나중에 Explorer/SCM을 **한 사이드바 슬롯에서 소스 전환**까지 맞추고 싶다면 `nvim-tree` 대신 `neo-tree.nvim`(filesystem + git_status 소스) 이전을 검토하면 된다.

## 권장 사용 흐름

### 상태 확인과 커밋

1. `<leader>gg`로 status를 연다.
2. 파일/헝크를 stage 한다.
3. `<leader>gc`로 commit popup을 연다.

### 변경 이력 확인

1. 현재 파일 기준이면 `<leader>gh`
2. 저장소 전체 기준이면 `<leader>gH`
3. staged/unstaged diff 전체 뷰는 `<leader>gd`

### 빠른 라인 단위 작업

- 현재 줄 blame: `<leader>gb`
- 현재 hunk 미리보기: `<leader>gp`
- 현재 hunk stage/reset: `<leader>gs`, `<leader>gr`
- hunk 이동: `]h`, `[h`

## 제안했지만 아직 미적용인 키맵

아래는 현재 충돌을 피하기 위해 아직 넣지 않은 후보들이다.

| 키맵 | 제안 동작 | 비고 |
|---|---|---|
| `<leader>gm` | Neogit merge popup | merge/rebase 동선 보강 |
| `<leader>gR` | Neogit rebase popup | 충돌 해결/히스토리 정리 |
| `<leader>gf` | Neogit fetch popup | pull과 분리해서 쓰기 좋음 |
| `<leader>gt` | Neogit stash popup 또는 tag popup | 팀 취향에 따라 선택 |
| `<leader>gu` | Gitsigns undo_stage_hunk | stage 후 되돌리기 |
| `<leader>gq` | Gitsigns setqflist | 변경 hunk 목록 점검 |
| `<leader>gn` | Gitsigns next_hunk | `]h`의 리더키 버전 |
| `<leader>gN` | Gitsigns prev_hunk | `[h`의 리더키 버전 |

## 메모

- `which-key`에서 `<leader>g`는 `Git` 그룹으로 표시된다.
- `neogit`은 floating, commit editor는 tab으로 열리도록 설정되어 있다.
- `ff`/`fg` 계열 검색 키맵은 Git 키맵과 별도이며, 숨김 파일 검색은 Telescope 쪽 문서를 따른다.
