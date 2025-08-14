# dotfiles
dotfiles for multiple platforms. maintained by chezmoi

## prerequiste

어쩔수없이 먼저 깔아야 하는것들

- rhel
  - zsh
  ```sh
  sudo dnf install zsh

  # in bash_profile
  export SHELL=`which zsh`
  exec `which zsh` -l
  ```

## 체크리스트

- [x] zshrc
  - [ ] 회사전용 로직을 발라내고, 공통 세팅만 유지한다.
- [x] zsh-dependencies(fzf, powershell, ..)
- [x] ghostty settings
- [x] 패키지 매니저 설치(brew, cask) 및 설치스크립트 작성
- [ ] karabiner 세팅(darwin)
- [ ] vimrc(nvim)
  - 개별 스트립트로 작성, 설치 여부 확인하기
- [ ] vscode common settings

## keybindings

- fzf 키바인딩
  - Ctrl + R (^R): 명령어 히스토리 검색
  - Ctrl + T (^T): 파일 선택해서 명령줄에 삽입
  - Alt(option) + C (`^[c`): 디렉터리 선택해서 이동 ,(`^[` : escape)

## 자주쓸것들

- 초기 설정 : `chezmoi init`
- 관리대상 추가 : `chezmoi add ~/.zshrc`
- 수정 : `chezmoi edit ~/.zshrc`
- 변경한 것 반영 : `chezmoi apply -v`
- chezmoi workdir 이동 : `chezmoi cd` , 나가기 : `exit`
- 다른 장비에서 fetch ONLY : `chezmoi init $GITHUB_USERNAME` or  `chezmoi init git@github.com:$GITHUB_USERNAME/dotfiles.git`
  - 미리 확인 : `chezmoi diff`
  - 추가될 것 반영 : `chezmoi apply -v` / 반영 전 수정하기 : `chezmoi edit $FILE` / merge : `chezmoi merge $FILE`
  - 위의것 일괄 반영 : `chezmoi update -v`
  - 귀찮다면 일괄 적용 : `chezmoi init --apply $GITHUB_USERNAME` or `chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git`
  - 한큐에 apply : `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME`
    - apply 는 떼고 해도 되겠다.
- 데이터수정 : `chezmoi edit-config`
  - 템플릿 원본위치 : `~/.config/chezmoi/chezmoi.toml`

```
[edit]
    command = "nvim"

[merge]
    command = "nvim"
    args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
```

- 템플릿 관리대상(?) 으로 새로 추가: `chezmoi add --template ~/.config/git/config`
  - 관리대상을 템플릿으로 바꾸기: `chezmoi chattr +template ~/.zshrc`

### 참고문서

- https://pozafly.github.io/tools/manage-with-rm-rf-erased-setting-file-chezmoi/
- https://haril.dev/blog/2023/03/26/chezmoi-awesome-dotfile-manager

