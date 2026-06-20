# fzf로 cmux 테마를 고르고 cmux themes set으로 적용한다. 커서 이동 시 라이브 프리뷰, esc 원복.
# 적용 결과는 ~/Library/Application Support/com.cmuxterm.app/config.ghostty (chezmoi 비관리)
# 공유 터미널 설정: ~/.config/ghostty/config — docs/ghostty.md

_cmuxtheme_bin() {
  [[ -n ${commands[cmux]:-} ]] && print -r -- "$commands[cmux]" && return 0
  [[ -x /Applications/cmux.app/Contents/Resources/bin/cmux ]] &&
    print -r -- /Applications/cmux.app/Contents/Resources/bin/cmux
}

# 현재 테마로 원복 (라이브 프리뷰 취소 시). 둘 다 inherit 이면 clear.
_cmuxtheme_restore() {
  local cmux_bin="$1" light="$2" dark="$3"
  if [[ "$light" == inherit && "$dark" == inherit ]]; then
    "$cmux_bin" themes clear >/dev/null 2>&1
  else
    "$cmux_bin" themes clear >/dev/null 2>&1
    [[ "$light" != inherit ]] && "$cmux_bin" themes set --light "$light" >/dev/null 2>&1
    [[ "$dark" != inherit ]] && "$cmux_bin" themes set --dark "$dark" >/dev/null 2>&1
  fi
  "$cmux_bin" reload-config >/dev/null 2>&1
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

  # 라이브 프리뷰: 커서가 항목에 머물면 즉시 both로 적용해 눈으로 확인. {2}=테마명.
  local preview_cmd="$cmux_bin themes set {2} >/dev/null 2>&1; $cmux_bin reload-config >/dev/null 2>&1"

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
      --header=" ↑↓ 라이브 프리뷰 · Enter 확정 · Esc 원복 (light: $current_light  dark: $current_dark)" \
      --bind "focus:execute-silent($preview_cmd)"
  )"
  local rc=$?

  # ESC/취소 → 프리뷰로 바꾼 테마를 원래대로 원복
  if [[ $rc -ne 0 || -z "$selection" ]]; then
    _cmuxtheme_restore "$cmux_bin" "$current_light" "$current_dark"
    return 130
  fi

  theme="${selection#*$'\t'}"
  [[ -n "$theme" ]] || return 1

  case "$mode" in
    light) "$cmux_bin" themes set --light "$theme" ;;
    dark)  "$cmux_bin" themes set --dark "$theme" ;;
    *)     "$cmux_bin" themes set "$theme" ;;
  esac
  "$cmux_bin" reload-config >/dev/null 2>&1
}
