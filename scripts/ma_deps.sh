#!/bin/sh
# Dependency resolution and tool-availability helpers for ma.sh.
# Sourcing this file only defines functions (no side effects).
#
# Callers must set:
#   MA_TOP   - repo root (contains apps/, tools/, scripts/)
#   MA_ROOT  - install prefix (for the availability functions; set by set_prefix)

# ma_reqvar <name> -> normalized "<NAME>_REQUIRES" (valid shell identifier)
ma_reqvar() {
  _var=$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | tr -c 'A-Z0-9' '_')
  printf '%s_REQUIRES' "$_var"
}

# ma_requires <kind> <name>  (kind = apps|tools) -> space-separated direct deps
ma_requires() {
  _vf="$MA_TOP/$1/$2/version.sh"
  [ -f "$_vf" ] || return 0
  _rv=$(ma_reqvar "$2")
  # shellcheck disable=SC1090
  ( . "$_vf" >/dev/null 2>&1; eval "printf '%s' \"\${$_rv:-}\"" )
}
