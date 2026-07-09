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

# placeholder until Task 5; keeps arg-validation testable now
ma_do_install() { echo "install $1 (mode=$2) not yet implemented" >&2; return 0; }

# temporary stubs until Task 6
ma_cmd_list() { echo "list not yet implemented" >&2; return 0; }
ma_cmd_installed() { echo "installed not yet implemented" >&2; return 0; }

case "${1:-help}" in
  -h|--help|help) ma_usage; exit 0 ;;
  install) shift; ma_cmd_install "$@"; exit $? ;;
  list)      shift; ma_cmd_list "$@";      exit $? ;;
  installed) shift; ma_cmd_installed "$@"; exit $? ;;
  *) echo "Error: unknown command '$1'" >&2; ma_usage >&2; exit 2 ;;
esac
