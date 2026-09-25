# Karabiner

Karabiner 설정은 GUI 에서 바꾸고 chezmoi 로 가져오는 방식으로 관리한다.

- 소스: `dot_config/private_karabiner/private_karabiner.json` (템플릿 아님)
- 대상: `~/.config/karabiner/karabiner.json` (darwin 에서만 배포)

## GUI 에서 바꾼 설정 반영하기

1. 받을 변경이 있는지 먼저 확인한다.

   ```sh
   chezmoi git pull
   chezmoi diff ~/.config/karabiner/karabiner.json
   ```

   - 출력이 없으면 → 2번으로
   - 출력이 있으면 → 다른 장비의 변경이 아직 적용되지 않은 상태다. GUI 에서 아직 안 바꿨다면 `chezmoi apply ~/.config/karabiner/karabiner.json` 으로 먼저 받는다. 이미 바꿨다면 아래 "양쪽이 다 바뀐 경우"를 따른다.

2. Karabiner GUI 에서 설정을 바꾼다.

3. 소스로 가져와 커밋한다.

   ```sh
   chezmoi re-add ~/.config/karabiner/karabiner.json
   chezmoi git -- diff              # 의도한 변경만 있는지 확인
   chezmoi git -- commit -am "feat(karabiner): ..."
   chezmoi git push
   ```

4. 다른 장비에서는 `chezmoi git pull` 후 `chezmoi apply` 한다.

## 주의

- `re-add` 는 합치지 않고 **소스를 실제 파일로 통째로 덮어쓴다.** 1번을 건너뛰면 다른 장비에서 올린 변경이 지워질 수 있다.
- Karabiner 는 저장할 때 항목 순서를 정렬하므로 diff 에 순서만 바뀐 줄이 섞일 수 있다.
- 잘못 덮어썼으면 `~/.config/karabiner/automatic_backups/` 의 날짜별 백업에서 되돌릴 수 있다.

## 양쪽이 다 바뀐 경우

소스(다른 장비)와 실제 파일(이 장비 GUI)이 둘 다 바뀌었으면 직접 합친다.

```sh
chezmoi merge ~/.config/karabiner/karabiner.json
```

vimdiff 가 실제 파일·소스·target 을 함께 열어준다. 합친 결과는 **소스 파일**(`private_karabiner.json`) 쪽에 저장한다.
그다음 `chezmoi apply ~/.config/karabiner/karabiner.json` 으로 실제 파일에 반영하고, 3번처럼 커밋한다.
