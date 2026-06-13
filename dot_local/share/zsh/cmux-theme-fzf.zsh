# fzf로 cmux(Ghostty) 테마를 고르고 cmux themes set으로 적용한다.
# 적용 결과는 ~/Library/Application Support/com.cmuxterm.app/config.ghostty 에만
# 기록되며 chezmoi 비관리(장비 로컬). 공유 설정은 ~/.config/ghostty/config — docs/ghostty.md

_cmuxtheme_bin() {
  [[ -n ${commands[cmux]:-} ]] && print -r -- "$commands[cmux]" && return 0
  [[ -x /Applications/cmux.app/Contents/Resources/bin/cmux ]] &&
    print -r -- /Applications/cmux.app/Contents/Resources/bin/cmux
}

_cmuxtheme_name() {
  local line="${1#??}"
  line="${line#"${line%%[![:space:]]*}"}"
  print -r -- "${line%"${line##*[![:space:]]}"}"
}

_cmuxtheme_preview() {
  local theme="$(_cmuxtheme_name "$1")"
  [[ -n "$theme" ]] || return 0

  local dir path
  for dir in \
    "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes" \
    "/Applications/cmux.app/Contents/Resources/ghostty/themes"
  do
    path="$dir/$theme"
    if [[ -f "$path" ]]; then
      if [[ -n ${commands[bat]:-} ]]; then
        bat --style=numbers --color=always --line-range :60 "$path"
      else
        sed -n '1,60p' "$path"
      fi
      return 0
    fi
  done
}

cmuxtheme() {
  local cmux_bin="$(_cmuxtheme_bin)"
  if [[ -z "$cmux_bin" ]]; then
    print -u2 "cmuxtheme: cmux CLI를 찾을 수 없습니다"
    return 1
  fi

  if [[ "$1" == clear ]]; then
    "$cmux_bin" themes clear
    return
  fi

  local mode=both
  [[ "$1" == --light ]] && mode=light
  [[ "$1" == --dark ]] && mode=dark

  if [[ -z ${commands[jq]:-} ]]; then
    print -u2 "cmuxtheme: jq가 필요합니다"
    return 1
  fi

  local json current_light current_dark
  json="$("$cmux_bin" themes list --json)" || {
    print -u2 "cmuxtheme: cmux themes list --json 실패"
    return 1
  }

  current_light="$(jq -r '.current.light // "inherit"' <<<"$json")"
  current_dark="$(jq -r '.current.dark // "inherit"' <<<"$json")"

  local -a theme_lines
  theme_lines=("${(@f)$(jq -r '
    .themes[]
    | (if .current_light and .current_dark then "● "
       elif .current_light then "L "
       elif .current_dark then "D "
       else "  " end) + .name
  ' <<<"$json")}")

  if (( ${#theme_lines[@]} == 0 )); then
    print -u2 "cmuxtheme: 사용 가능한 테마가 없습니다"
    return 1
  fi

  local selection theme
  selection="$(
    print -rl -- "${theme_lines[@]}" | fzf \
      --height=40% --layout=reverse --border \
      --prompt='cmux theme> ' \
      --header="light: $current_light  dark: $current_dark" \
      --preview='_cmuxtheme_preview {}' \
      --preview-window=right:50%:wrap
  )" || return 130

  theme="$(_cmuxtheme_name "$selection")"
  [[ -n "$theme" ]] || return 1

  case "$mode" in
    light) "$cmux_bin" themes set --light "$theme" ;;
    dark)  "$cmux_bin" themes set --dark "$theme" ;;
    *)     "$cmux_bin" themes set "$theme" ;;
  esac
}
