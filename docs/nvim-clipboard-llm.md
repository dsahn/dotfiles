# Neovim 복사·붙여넣기

- `clipboard = unnamedplus` 설정으로 기본 yank(`y`, `yy`, Visual `y`)가 시스템 클립보드에 복사된다
- Visual 모드에서 `p`는 `"_dP`로 매핑되어, 선택 영역 치환 시에도 기존 클립보드 내용이 유지된다
- 명시적으로 시스템 클립보드를 지정하려면 `"+y`, `"+p`를 사용할 수 있다

예시:

- `yiw`: 커서 아래 단어 복사 (시스템 클립보드)
- `yy`: 현재 줄 복사 (시스템 클립보드)
- Visual 선택 후 `y`: 선택 영역 복사
- Visual 선택 후 `p`: 선택 영역을 클립보드 내용으로 치환하고 클립보드 내용은 유지
- `"+y`, `"+p`: 시스템 클립보드를 명시적으로 사용

# 외부 LLM CLI 연동

- `<leader>ao`: `opencode`를 분할 터미널로 실행
- Normal `<leader>ac`: AI 에이전트 **폴백** — 설치된 순서대로 `claude`(Claude Code CLI) → `codex` → 없으면 `cursor-agent` 플로팅 (`xTacobaco/cursor-agent.nvim`의 `:CursorAgent`)
  - `claude` / `codex`가 있으면 하단 분할 터미널로 해당 바이너리만 실행
  - 둘 다 없고 `cursor-agent`만 있으면 플로팅 터미널 토글
  - 모두 없으면 경고
- Visual `<leader>ac` / Normal `<leader>aC`: `:CursorAgentSelection` / `:CursorAgentBuffer` — **cursor-agent**가 있을 때만 동작 (플러그인 전용)
- 창 닫기
  - `cursor-agent` 플로팅: `<leader>ac`로 다시 토글하거나 `q` (터미널 입력 모드면 `Ctrl-\` `Ctrl-n` 후 `q`)
  - `claude` / `codex` 분할: 해당 버퍼에서 `:q` 등으로 닫기
- 용어 정리
  - `selection` 전송: Visual 모드로 선택한 범위만 보냄
  - `buffer` 전송: 현재 파일 전체(버퍼 전체 내용)를 보냄
