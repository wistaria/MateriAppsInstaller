#!/bin/sh
# Assert that each version.sh is declarative (only comments/blank lines and
# simple `NAME=...` or `export NAME=...` assignments with no top-level shell
# metacharacters), so it can safely be sourced by the resolver.
#
# A $(...) command substitution on the RHS is allowed, even if it contains a
# pipe (e.g. `X=$(echo 1 | tr a b)`), because that pipe is scoped inside the
# substitution rather than chained with the rest of the line. What is
# rejected is any *top-level* `;`, `&`, `|`, or backtick, since those would
# let a sourced version.sh execute an extra command (e.g.
# `FOO=1; rm -rf /tmp/x`, `FOO=bar && rm -rf /`, `` FOO=`rm -rf /` ``).
# Exits nonzero listing offenders.
set -u
SELF_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$SELF_DIR")

if [ "$#" -gt 0 ]; then set -- "$@"; else
  set -- "$ROOT"/apps/*/version.sh "$ROOT"/tools/*/version.sh
fi

assign_re='^[[:space:]]*(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*='

# Checks one file; echoes offending lines (if any) and returns 1 when the
# file is non-declarative. Uses its own positional parameters so it does not
# disturb the caller's file list.
check_file() {
  f="$1"
  lines=$(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$f")
  bad=""

  old_ifs=$IFS
  IFS='
'
  set -f
  # shellcheck disable=SC2086
  set -- $lines
  set +f
  IFS=$old_ifs

  for line in "$@"; do
    if ! printf '%s\n' "$line" | grep -qE "$assign_re"; then
      bad="$bad
$line"
      continue
    fi
    # Strip $(...) command-substitution groups (non-nested) and quoted
    # spans, then check what remains for top-level metacharacters.
    stripped=$(printf '%s\n' "$line" \
      | sed -e 's/\$([^)]*)//g' -e "s/'[^']*'//g" -e 's/"[^"]*"//g')
    case "$stripped" in
      *[\;\&\|\`]*)
        bad="$bad
$line"
        ;;
    esac
  done

  if [ -n "$bad" ]; then
    echo "Non-declarative line(s) in $f:" >&2
    printf '%s\n' "$bad" | sed '/^$/d' >&2
    return 1
  fi
  return 0
}

rc=0
for f in "$@"; do
  [ -f "$f" ] || continue
  check_file "$f" || rc=1
done
exit "$rc"
