#!/bin/sh
# Unified entry point for MateriApps Installer.
#   sh ma.sh install <app> [mode]   install an app and the tools it needs
#   sh ma.sh list                   list available apps/tools and versions
#   sh ma.sh installed              list installed components under MA_ROOT
#   sh ma.sh help                   show this help
set -u

MA_TOP=$(cd "$(dirname "$0")" && pwd)
export MA_TOP
. "$MA_TOP/scripts/ma_deps.sh"

ma_usage() {
  cat <<EOF
Usage: sh ma.sh <command> [args]

Commands:
  install <app> [mode]   Resolve tool dependencies, build the missing ones,
                         then install <app> (mode defaults to 'default').
  list                   List installable apps and tools with pinned versions.
  installed              List components already installed under MA_ROOT.
  help                   Show this help.
EOF
}

ma_cmd_install() {
  app="${1:-}"
  mode="${2:-default}"
  if [ -z "$app" ]; then
    echo "Error: 'install' requires an application name" >&2
    ma_usage >&2; return 2
  fi
  if [ ! -d "$MA_TOP/apps/$app" ]; then
    echo "Error: unknown app '$app' (see 'sh ma.sh list')" >&2
    return 2
  fi
  if [ ! -d "$MA_TOP/apps/$app/config/$mode" ]; then
    echo "Error: unknown mode '$mode' for '$app'. Available:" >&2
    ls -1 "$MA_TOP/apps/$app/config" >&2
    return 2
  fi
  ma_do_install "$app" "$mode"   # implemented in Task 5
}

ma_do_install() {
  app="$1"; mode="$2"

  # util.sh/env.sh predate 'set -u' and reference vars (e.g. LD_LIBRARY_PATH)
  # that are legitimately unset in a fresh shell; relax nounset only while
  # sourcing them, without touching those files.
  set +u
  . "$MA_TOP/scripts/util.sh"
  set_prefix
  set -u
  if [ ! -f "$MA_ROOT/env.sh" ]; then
    echo "Error: $MA_ROOT/env.sh not found; run 'sh setup/setup.sh' first" >&2
    return 1
  fi
  set +u
  . "$MA_ROOT/env.sh"
  set -u

  order=$(ma_resolve "$app") || return 1   # cycle/unknown already reported

  if [ -z "$(ma_requires apps "$app")" ]; then
    echo "Notice: no dependency metadata for '$app'; assuming required tools" \
         "are already installed (install them first if the build fails)." >&2
  fi
  if [ "$mode" != default ] && [ -n "$order" ]; then
    echo "Notice: dependencies build in their default mode, not '$mode';" \
         "pre-build them in a matching toolchain if that matters." >&2
  fi

  # build/skip each tool in dependency order
  for tool in $order; do
    case "$(ma_tool_status "$tool")" in
      available) echo "== dependency '$tool' already available, skipping" ;;
      partial)
        echo "Error: '$tool' looks partially installed." >&2
        echo "Remove $MA_ROOT/$tool/$tool-* and re-run." >&2
        return 1 ;;
      absent)
        echo "== building dependency '$tool'"
        ( cd "$MA_TOP/tools/$tool" && sh install.sh && sh link.sh ) || {
          echo "Error: failed to build dependency '$tool' of '$app'" >&2
          return 1; }
        set +u
        . "$MA_ROOT/env.sh"   # make it visible to later checks/builds
        set -u ;;
    esac
  done

  echo "== installing app '$app' (mode=$mode)"
  ( cd "$MA_TOP/apps/$app" && sh install.sh "$mode" && sh link.sh ) || {
    echo "Error: failed to install '$app'" >&2
    return 1; }
  echo "== done: $app"
}

ma_cmd_list() {
  echo "[Applications]"
  for d in "$MA_TOP"/apps/*/; do
    [ -f "$d/version.sh" ] || continue
    name=$(basename "$d")
    ver=$( . "$d/version.sh" >/dev/null 2>&1; printf '%s' "${__VERSION__:-?}" )
    if [ -n "$(ma_requires apps "$name")" ]; then tag=" [deps]"; else tag=""; fi
    printf '  %s %s%s\n' "$name" "$ver" "$tag"
  done
  echo "[Tools]"
  for d in "$MA_TOP"/tools/*/; do
    [ -f "$d/version.sh" ] || continue
    name=$(basename "$d")
    ver=$( . "$d/version.sh" >/dev/null 2>&1; printf '%s' "${__VERSION__:-?}" )
    printf '  %s %s\n' "$name" "$ver"
  done
}

ma_cmd_installed() {
  # util.sh predates 'set -u' and references vars that are legitimately
  # unset in a fresh shell (see ma_do_install above); relax nounset only
  # while sourcing it and calling set_prefix.
  set +u
  . "$MA_TOP/scripts/util.sh"; set_prefix
  set -u
  # Tools register an unversioned symlink under env.d/; apps register one
  # under $MA_ROOT/<app>/<app>vars.sh (both also keep versioned files, so
  # the unversioned symlink location is what distinguishes them).
  echo "[Tools]"
  for m in "$MA_ROOT"/env.d/*vars.sh; do
    [ -e "$m" ] || continue
    printf '  %s\n' "$(basename "$m" | sed 's/vars\.sh$//')"
  done
  echo "[Applications]"
  for d in "$MA_ROOT"/*/; do
    name=$(basename "$d")
    [ -e "$d${name}vars.sh" ] || continue
    printf '  %s\n' "$name"
  done
}

case "${1:-help}" in
  -h|--help|help) ma_usage; exit 0 ;;
  install) shift; ma_cmd_install "$@"; exit $? ;;
  list)      shift; ma_cmd_list "$@";      exit $? ;;
  installed) shift; ma_cmd_installed "$@"; exit $? ;;
  *) echo "Error: unknown command '$1'" >&2; ma_usage >&2; exit 2 ;;
esac
