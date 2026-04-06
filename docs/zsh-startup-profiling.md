# zsh 시작 성능 측정 (zprof)

`.zshrc`에 상시 넣지 않고, **병목을 볼 때만** 아래를 잠깐 적용한 뒤 제거하면 됩니다.

## 무엇을 보는지

- `zprof`는 zsh **함수·builtin·`source`된 스크립트** 쪽 CPU 시간을 요약합니다.
- `mise`, `java_home`처럼 **외부 프로세스**가 오래 걸리는 구간은 표에 약하게 나올 수 있으므로, 전체 체감은 아래 **벽시계**도 같이 보는 것이 좋습니다.

## 1. 벽시계만 (가장 단순)

```bash
command time zsh -i -c exit
```

## 2. zprof로 구간별 시간

### (1) `~/.zshrc` 임시 수정

Powerlevel10k **instant prompt 블록 바로 아래**(가능하면 그 다음 줄)에 추가:

```zsh
zmodload zsh/zprof
```

파일 **맨 끝**에 추가:

```zsh
zprof
```

instant prompt는 가능한 한 위에 두는 것이 좋습니다. 측정이 끝나면 위 두 곳을 **반드시 삭제**하세요.

chezmoi를 쓰는 경우, 배포본은 `dot_zshrc.tmpl`이므로 로컬에서만 잠깐 고쳤다가 되돌리거나, 적용된 `~/.zshrc`만 잠깐 수정해도 됩니다(다음 `chezmoi apply`에 덮어쓰이므로 주의).

### (2) 실행

```bash
zsh -i -c exit
```

표가 터미널에 출력됩니다.

### (3) 벽시계와 함께

```bash
command time zsh -i -c exit
```

## 3. 결과 해석 팁

- 상위에 `compinit`, `compaudit`이 보이면 completion 초기화·권한 검사 쪽을 의심합니다.
- `_mise_hook` 등이 크면 mise **훅 기반** 활성화가 매 프롬프트/디렉터리 전환마다 비용을 내는지 확인합니다. (이 저장소 설정은 shims·지연 로드 등으로 줄이는 방향을 취합니다.)
- `_omz_source`, 특정 플러그인·테마가 크면 해당 구성을 줄이거나 지연 로드를 검토합니다.

## 4. 참고

- zsh 매뉴얼: `zshmodules(1)`의 `zsh/zprof`.
- 비대화형 셸이나 CI에서는 `-i` 없이 측정하면 의미가 달라질 수 있으니, **대화형 시작**을 보통 기준으로 합니다.
