# Neovim Git Workflows

[nvim.md](nvim.md) 하위 문서. 사이드바 변경 트리는 `neo-tree.nvim`의 `git_status` 소스로, 나머지 Git 작업은 `gitsigns` + `diffview.nvim` + `neogit` 조합으로 사용한다.

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
| `<leader>gE` | git 변경 트리 사이드바 토글 (neo-tree) | neo-tree |
| `]h` | 다음 hunk | gitsigns |
| `[h` | 이전 hunk | gitsigns |

<span id="nvim-sidebar-git-views"></span>

## 사이드바: 파일 트리 vs 변경(또는 diff) 뷰

사이드바는 **`neo-tree.nvim`**으로 통일했다. 소스는 `filesystem`과 `git_status`만 켜 두었고, 창 상단 **winbar 탭**으로 소스를 바꿀 수 있다. 트리 안에서는 기본 매핑대로 `<` / `>`로 이전·다음 소스로도 전환된다.

| 목적 | 추천 진입 | 설명 |
|------|-----------|------|
| 워크스페이스 전체 파일 트리 | `<leader>e` | neo-tree `filesystem`(열 때 현재 파일 `reveal`) |
| **변경 파일만** 트리(같은 왼쪽 슬롯) | `<leader>gE` | neo-tree `git_status` |
| staged/unstaged **diff** 패널 | `<leader>gd` | `diffview` 왼쪽 `file_panel` + diff. `<leader>gx`로 닫기 |
| 변경 파일 빠른 선택(플로팅) | `<leader>gS` | `Telescope git_status` |
| 인라인 하이라이트·헝크 | `gitsigns` | 버퍼 기준 동작 |

파일을 트리에서 열면 이전 `nvim-tree`의 `quit_on_open`과 같이 **neo-tree 창을 자동으로 닫도록** `file_opened` 이벤트로 맞춰 두었다.

`<leader>e`로 시작하는 다른 키맵과의 **맵 충돌·대기**를 피하려고 git 전용 사이드바는 `<leader>gE`에 두었다.

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
