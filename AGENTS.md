# 커밋 규칙

이 레포의 커밋 메시지는 한글 Conventional Commit 형식을 사용한다.

## 형식

```text
<type>(<scope>): <subject>

<body>
```

- `scope`와 `body`는 선택
- 제목은 50자 이내
- 본문은 필요할 때만 작성하고 72자 안팎으로 줄바꿈

## 타입

- `feat`: 새로운 기능 추가
- `fix`: 버그 수정
- `docs`: 문서 수정
- `refactor`: 동작 변화 없는 구조 개선
- `test`: 테스트 추가/수정
- `chore`: 설정, 스크립트, 의존성, 파일 이동
- `style`: 포맷팅, 공백, 정렬 등 비기능 변경

## 제목 규칙

- 한글로 작성
- 명령조로 작성
- 첫 글자는 소문자로 시작
- 마침표를 붙이지 않음
- 무엇을 바꿨는지 바로 드러나게 씀

좋은 예:

```text
docs: git 문서를 docs 디렉토리로 분리
fix(nvim): telescope 숨김 검색 키맵 충돌 수정
chore: 커서 규칙 파일을 AGENTS로 이동
```

피해야 할 예:

```text
README 수정
fix: 버그 수정함.
chore: 이것저것 정리
```

## 스코프 규칙

스코프는 꼭 필요할 때만 사용한다.

- 사용 예: `fix(nvim)`, `docs(git)`, `refactor(zsh)`
- 너무 넓거나 모호한 스코프는 피한다

## 본문 규칙

본문에는 "무엇"보다 "왜"를 우선해서 적는다.

- 배경이나 문제 상황
- 선택한 방식의 이유
- 주의할 점이나 영향 범위

예:

```text
fix(nvim): telescope 숨김 검색 로딩 오류 수정

초기 로드 시 telescope 모듈을 바로 require 하면서
lazy 로딩 이전에 에러가 발생하던 문제를 수정했다.
관련 모듈은 키 실행 시점에만 불러오도록 변경했다.
```

## 설정과 문서 동기화

**설정·스크립트·도구 구성**(chezmoi 관리 대상, `dot_*`·템플릿·`docs/`와 맞물린 README 등)을 바꿀 때, **키맵·패키지·운영 절차처럼 문서에 적혀 있거나 적을 만한 내용**이 바뀌면 사용자가 그걸 문서로 찾는다고 가정하고 **`docs/`와 [README.md](README.md)를 실제 동작과 맞춘다.**

- 변경 범위에 해당하는 주제 문서(예: Neovim은 [docs/nvim.md](docs/nvim.md), zsh는 [docs/zsh-startup-profiling.md](docs/zsh-startup-profiling.md) 등)를 갱신한다.
- README에 요약·체크리스트·키바인딩 등으로 같은 내용이 드러나 있으면 그 부분도 함께 수정한다.
- 새 주제가 생기면 `docs/`에 문서를 두고 README의 관련 절에서 링크하는 편이 좋다.

## 이 레포에서 관리하지 않는 것

**Claude Code 설정(`~/.claude/`)은 이 레포가 아니라 my-skills 레포에서 관리한다.**

- `~/.claude/settings.json`, `~/.claude/hooks/`를 이 레포 작업 중에 직접 고치지 않는다. 안전장치 hook(파괴적 git 명령 확인 등)은 my-skills plugin이, 알림음 등 취향 설정은 my-skills의 snippet이 담당한다.
- `~/.claude/`를 chezmoi 관리 대상(`dot_claude/` 등)으로 추가하지 않는다. `settings.json`은 Claude Code가 permissions 등을 계속 고치는 파일이라 `re-add`와 충돌한다.
- 이 레포 작업 중 hook·권한 설정이 필요해 보이면 직접 바꾸지 말고, my-skills 쪽에서 처리하도록 사용자에게 알린다.

## Best Practice

- 한 커밋에는 한 가지 의도만 담는다
- 기능 추가와 문서 정리는 가능하면 분리한다
- 리네임, 이동, 설정 변경은 `chore`를 우선 검토한다
- 사용자 영향이 있는 동작 변경은 `feat`나 `fix`를 우선 검토한다
- 제목만 보고도 변경 의도를 이해할 수 있어야 한다
- 막연한 표현보다 대상과 동작을 구체적으로 쓴다
  - 예: `docs: README 업데이트`보다 `docs: git 키맵 문서 분리`
- 커밋 직전에는 staged diff 기준으로 메시지를 쓴다
- 큰 변경은 작은 의미 단위 커밋으로 나누는 편이 좋다
