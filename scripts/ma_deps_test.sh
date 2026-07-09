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

# --- ma_resolve: diamond + transitive ---
# app hphix -> cmake, openmpix, scalapackx ; scalapackx -> openmpix, lapackx
mkdir -p "$FIX/apps/hphix" "$FIX/tools/cmakex" "$FIX/tools/openmpix" \
         "$FIX/tools/lapackx" "$FIX/tools/scalapackx"
printf 'HPHIX_REQUIRES="cmakex openmpix scalapackx"\n'  > "$FIX/apps/hphix/version.sh"
printf 'SCALAPACKX_REQUIRES="openmpix lapackx"\n'       > "$FIX/tools/scalapackx/version.sh"
: > "$FIX/tools/cmakex/version.sh"
: > "$FIX/tools/openmpix/version.sh"
: > "$FIX/tools/lapackx/version.sh"

order=$(ma_resolve hphix) || fail "resolve hphix exited nonzero"
# openmpix must appear exactly once, before scalapackx; lapackx before scalapackx
assert_eq "$(printf '%s\n' "$order" | grep -c '^openmpix$')" "1" "openmpix once (diamond)"
pos_omp=$(printf '%s\n' "$order" | grep -n '^openmpix$'   | cut -d: -f1)
pos_lap=$(printf '%s\n' "$order" | grep -n '^lapackx$'    | cut -d: -f1)
pos_sca=$(printf '%s\n' "$order" | grep -n '^scalapackx$' | cut -d: -f1)
[ "$pos_omp" -lt "$pos_sca" ] || fail "openmpix must precede scalapackx"
[ "$pos_lap" -lt "$pos_sca" ] || fail "lapackx must precede scalapackx"

# --- ma_resolve: cycle detection ---
mkdir -p "$FIX/apps/cyc" "$FIX/tools/a" "$FIX/tools/b"
printf 'CYC_REQUIRES="a"\n' > "$FIX/apps/cyc/version.sh"
printf 'A_REQUIRES="b"\n'   > "$FIX/tools/a/version.sh"
printf 'B_REQUIRES="a"\n'   > "$FIX/tools/b/version.sh"
if ma_resolve cyc >/dev/null 2>&1; then fail "cycle should exit nonzero"; fi

# --- ma_resolve: unknown tool ---
mkdir -p "$FIX/apps/badref"
printf 'BADREF_REQUIRES="ghost"\n' > "$FIX/apps/badref/version.sh"
if ma_resolve badref >/dev/null 2>&1; then fail "unknown tool should exit nonzero"; fi

# --- ma_resolve: app with no deps -> empty output, exit 0 ---
mkdir -p "$FIX/apps/nodeps"; : > "$FIX/apps/nodeps/version.sh"
order=$(ma_resolve nodeps) || fail "nodeps should exit 0"
assert_eq "$order" "" "nodeps empty order"

# --- ma_tool_status ---
MA_ROOT="$FIX/maroot"
mkdir -p "$MA_ROOT/env.d"
# tool st1 with a version.sh (needed for prefix path)
mkdir -p "$FIX/tools/st1"; printf '__VERSION__=1.0\n__MA_REVISION__=1\n' > "$FIX/tools/st1/version.sh"

# absent: nothing installed, no find.sh
assert_eq "$(ma_tool_status st1)" "absent" "status absent"

# partial: prefix dir exists, no marker
mkdir -p "$MA_ROOT/st1/st1-1.0-1"
assert_eq "$(ma_tool_status st1)" "partial" "status partial"

# available: readable marker present
target="$MA_ROOT/st1/st1vars-1.0-1.sh"; : > "$target"
ln -s "$target" "$MA_ROOT/env.d/st1vars.sh"
assert_eq "$(ma_tool_status st1)" "available" "status available (marker)"

# dangling marker -> not available (falls back to partial, prefix still there)
rm -f "$target"
assert_eq "$(ma_tool_status st1)" "partial" "status dangling marker -> partial"

# find.sh available for a tool with no installer state
mkdir -p "$FIX/tools/st2"; printf '__VERSION__=1.0\n__MA_REVISION__=1\n' > "$FIX/tools/st2/version.sh"
printf 'MA_HAVE_ST2=yes\n' > "$FIX/tools/st2/find.sh"
assert_eq "$(ma_tool_status st2)" "available" "status find.sh yes"

# find.sh that derives its own dir from $0 and reads a sibling file -- this
# mirrors real find.sh files (lapack, boost, fftw, eigen3, gsl, hdf5,
# libffi, nfft, openssl, tcltk, zlib), which do
# SCRIPT_DIR=$(cd "$(dirname $0)"; pwd) and then read paths under
# SCRIPT_DIR. If ma__find_have sources find.sh without $0 pointing at
# find.sh itself, dirname $0 resolves to the wrong directory, the sibling
# file can't be read, and MA_HAVE_ST3 never becomes yes.
mkdir -p "$FIX/tools/st3"; printf '__VERSION__=1.0\n__MA_REVISION__=1\n' > "$FIX/tools/st3/version.sh"
printf 'present\n' > "$FIX/tools/st3/sibling.marker"
cat > "$FIX/tools/st3/find.sh" <<'EOF'
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
if [ -r "${SCRIPT_DIR}/sibling.marker" ]; then
  MA_HAVE_ST3=yes
else
  MA_HAVE_ST3=no
fi
EOF
assert_eq "$(ma_tool_status st3)" "available" \
  "status find.sh deriving SCRIPT_DIR from \$0 (sibling-file lookup)"

# --- lint_version_sh ---
LINT="$THIS_DIR/lint_version_sh.sh"
ok="$FIX/ok.sh"; bad="$FIX/bad.sh"; subst="$FIX/subst.sh"
compound1="$FIX/compound1.sh"; compound2="$FIX/compound2.sh"; btick="$FIX/btick.sh"
printf '# comment\nFOO="1.0"\nexport BAR=baz\n' > "$ok"
printf 'FOO=1\nrm -rf /tmp/x\n' > "$bad"
printf 'V=$(echo 1 | tr a b)\n' > "$subst"
printf 'FOO=1; rm -rf /tmp/x\n' > "$compound1"
printf 'FOO=bar && echo x\n' > "$compound2"
printf 'FOO=`echo x`\n' > "$btick"
sh "$LINT" "$ok"    || fail "lint should accept assignments+comments"
sh "$LINT" "$subst" || fail "lint should accept assignment with command substitution"
sh "$LINT" "$bad"   && fail "lint should reject a bare command"
sh "$LINT" "$compound1" && fail "lint should reject a semicolon-chained command"
sh "$LINT" "$compound2" && fail "lint should reject an &&-chained command"
sh "$LINT" "$btick"     && fail "lint should reject backtick command substitution"

# real tree must be clean (all current version.sh are declarative)
sh "$LINT" || fail "all repo version.sh should pass the declarative lint"

[ "$FAILED" -eq 0 ] && echo "ALL TESTS PASSED"
exit "$FAILED"
