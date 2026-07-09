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

# ma__tool_prefix_exists <tool> -> 0 if $MA_ROOT/<t>/<t>-<ver>-<rev> exists
ma__tool_prefix_exists() {
  local _t="$1"
  ( . "$MA_TOP/tools/$_t/version.sh" >/dev/null 2>&1
    [ -n "${__VERSION__:-}" ] || exit 1
    [ -d "$MA_ROOT/$_t/$_t-${__VERSION__}-${__MA_REVISION__}" ] )
}

# ma__find_have <tool> -> value of MA_HAVE_<TOOL> from tools/<t>/find.sh (or empty)
ma__find_have() {
  local _t="$1" _hv _res
  _hv="MA_HAVE_$(printf '%s' "$_t" | tr '[:lower:]' '[:upper:]' | tr -c 'A-Z0-9' '_')"
  # find.sh re-derives SCRIPT_DIR from $0 (as it would when run directly by
  # install.sh). If we just `. find.sh` here, $0 stays ma.sh's own $0, so
  # `dirname $0` resolves at the wrong depth. Run it in a fresh `sh -c` with
  # $0 pointed at find.sh itself so its own `dirname $0` is correct.
  _res=$(sh -c '. "$0" >/dev/null 2>&1; eval "printf %s \"\${'"$_hv"':-}\""' \
           "$MA_TOP/tools/$_t/find.sh")
  printf '%s' "$_res"
}

# ma_tool_status <tool> -> available | partial | absent
ma_tool_status() {
  local _t="$1" _marker="$MA_ROOT/env.d/${1}vars.sh"
  if [ -f "$_marker" ] && [ -r "$_marker" ]; then
    echo available; return 0
  fi
  if ma__tool_prefix_exists "$_t"; then
    echo partial; return 0
  fi
  if [ -f "$MA_TOP/tools/$_t/find.sh" ] && [ "$(ma__find_have "$_t")" = "yes" ]; then
    echo available; return 0
  fi
  echo absent
}
