#!/bin/sh
# Unit tests for scripts/ma_deps.sh. Run: sh scripts/ma_deps_test.sh
set -u

THIS_DIR=$(cd "$(dirname "$0")" && pwd)
. "$THIS_DIR/ma_deps.sh"

FAILED=0
fail() { echo "FAIL: $1"; FAILED=1; }
assert_eq() { # <got> <want> <msg>
  if [ "$1" != "$2" ]; then fail "$3: expected [$2] got [$1]"; fi
}

# --- fixture repo tree ---
FIX=$(mktemp -d)
trap 'rm -rf "$FIX"' EXIT
mkdir -p "$FIX/apps/app1" "$FIX/tools/t1" "$FIX/tools/t2"
cat > "$FIX/apps/app1/version.sh" <<'EOF'
APP1_VERSION="1.0"
__NAME__=app1
APP1_REQUIRES="t1 t2"
EOF
cat > "$FIX/tools/t1/version.sh" <<'EOF'
T1_VERSION="1.0"
__NAME__=t1
EOF
# t2 has no version.sh REQUIRES var at all
cat > "$FIX/tools/t2/version.sh" <<'EOF'
T2_VERSION="1.0"
__NAME__=t2
EOF
# shellcheck disable=SC2034
MA_TOP="$FIX"

# --- ma_reqvar ---
assert_eq "$(ma_reqvar hphi)" "HPHI_REQUIRES" "reqvar simple"
assert_eq "$(ma_reqvar gcc-wrapper)" "GCC_WRAPPER_REQUIRES" "reqvar dash"
assert_eq "$(ma_reqvar gcc10)" "GCC10_REQUIRES" "reqvar digits"

# --- ma_requires ---
assert_eq "$(ma_requires apps app1)" "t1 t2" "requires app1"
assert_eq "$(ma_requires tools t1)" "" "requires t1 empty"
assert_eq "$(ma_requires tools nope)" "" "requires missing dir empty"

[ "$FAILED" -eq 0 ] && echo "ALL TESTS PASSED"
exit "$FAILED"
