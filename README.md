# dotfiles
dotfiles for multiple platforms. maintained by chezmoi

## 체크리스트

- [x] zshrc
- [ ] vimrc(nvim)
- [ ] zsh-dependencies(fzf, powershell, ..)
- [ ] ghostty settings

## 자주쓸것들

- 초기 설정 : `chezmoi init`
- 관리대상 추가 : `chezmoi add ~/.zshrc`
- 수정 : `chezmoi edit ~/.zshrc`
- 변경한 것 반영 : `chezmoi apply -v`
- chezmoi workdir 이동 : `chezmoi cd` , 나가기 : `exit`
- 템플릿 원본위치, `chezmoi edit-config` 로도 수정 가능하다.
  - `~/.config/chezmoi/chezmoi.toml`
- 다른 장비에서 땡겨오기 : `chezmoi init git@github.com:$GITHUB_USERNAME/dotfiles.git`  
  - 미리 확인 : `chezmoi diff`
  - 추가될 것 반영 : `chezmoi apply -v` / 반영 전 수정하기 : `chezmoi edit $FILE` / merge : `chezmoi merge $FILE`
  - 위의것 일괄 반영 : `chezmoi update -v`
  - 귀찮다면 일괄 적용 : `chezmoi init --apply $GITHUB_USERNAME` or `chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git`
- config 설정
  - `chezmoi edit-config`
```
[edit]
    command = "nvim"

[merge]
    command = "nvim"
    args = ["-d", "{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]
```

### 참고문서

- https://haril.dev/blog/2023/03/26/chezmoi-awesome-dotfile-manager
