# fzf로 cmux 테마를 고르고 cmux themes set으로 적용한다.
# 적용 결과는 ~/Library/Application Support/com.cmuxterm.app/config.ghostty (chezmoi 비관리)
# 공유 터미널 설정: ~/.config/ghostty/config — docs/ghostty.md

_cmuxtheme_bin() {
  [[ -n ${commands[cmux]:-} ]] && print -r -- "$commands[cmux]" && return 0
  [[ -x /Applications/cmux.app/Contents/Resources/bin/cmux ]] &&
    print -r -- /Applications/cmux.app/Contents/Resources/bin/cmux
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

  local json current_light current_dark selection theme
  json="$("$cmux_bin" themes list --json)" || {
    print -u2 "cmuxtheme: cmux themes list --json 실패"
    return 1
  }

  current_light="$(jq -r '.current.light // "inherit"' <<<"$json")"
  current_dark="$(jq -r '.current.dark // "inherit"' <<<"$json")"

  if ! jq -e '.themes | length > 0' <<<"$json" >/dev/null; then
    print -u2 "cmuxtheme: 사용 가능한 테마가 없습니다"
    return 1
  fi

  selection="$(
    jq -r '
      .themes[]
      | (if .current_light and .current_dark then "● "
         elif .current_light then "L "
         elif .current_dark then "D "
         else "  " end) + .name + "\t" + .name
    ' <<<"$json" | fzf \
      --delimiter=$'\t' \
      --with-nth=1 \
      --height=40% --layout=reverse --border \
      --prompt='cmux theme> ' \
      --header="light: $current_light  dark: $current_dark"
  )" || return 130

  theme="${selection#*$'\t'}"
  [[ -n "$theme" ]] || return 1

  case "$mode" in
    light) "$cmux_bin" themes set --light "$theme" ;;
    dark)  "$cmux_bin" themes set --dark "$theme" ;;
    *)     "$cmux_bin" themes set "$theme" ;;
  esac
}
