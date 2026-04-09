# Neovim Git Workflows

Neovim 안에서 Git 작업은 `gitsigns` + `diffview.nvim` + `neogit` 조합으로 사용한다.

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
| `]h` | 다음 hunk | gitsigns |
| `[h` | 이전 hunk | gitsigns |

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
