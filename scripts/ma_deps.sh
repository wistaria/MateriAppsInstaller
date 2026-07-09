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

# Exact whole-line membership test (never substring).
ma__member() { printf '%s\n' "$2" | grep -qxF "$1"; }

# DFS over tool deps. Uses caller-scoped _visited/_stack/_out (dynamic scope).
ma__visit_tool() {
  local _t="$1" _d
  ma__member "$_t" "$_visited" && return 0
  if ma__member "$_t" "$_stack"; then
    echo "Error: dependency cycle involving '$_t'" >&2
    return 1
  fi
  if [ ! -d "$MA_TOP/tools/$_t" ]; then
    echo "Error: unknown tool '$_t' in a REQUIRES list" >&2
    return 1
  fi
  _stack="$_stack
$_t"
  for _d in $(ma_requires tools "$_t"); do
    ma__visit_tool "$_d" || return 1
  done
  _stack=$(printf '%s\n' "$_stack" | grep -vxF "$_t")
  _visited="$_visited
$_t"
  _out="$_out$_t
"
}

# ma_resolve <app> -> transitive tool deps, dependency order, one per line.
ma_resolve() {
  local _app="$1" _d
  local _visited="" _stack="" _out=""
  for _d in $(ma_requires apps "$_app"); do
    ma__visit_tool "$_d" || return 1
  done
  printf '%s' "$_out"
}
