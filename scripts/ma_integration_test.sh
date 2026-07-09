#!/bin/sh
# Integration tests for ma.sh. Run: sh scripts/ma_integration_test.sh
set -u
THIS_DIR=$(cd "$(dirname "$0")" && pwd)
TOP=$(cd "$THIS_DIR/.." && pwd)
MA="$TOP/ma.sh"

FAILED=0
fail() { echo "FAIL: $1"; FAILED=1; }

# usage / help
sh "$MA" >/dev/null 2>&1        || fail "no-args should exit 0"
sh "$MA" help >/dev/null 2>&1   || fail "help should exit 0"
sh "$MA" --help >/dev/null 2>&1 || fail "--help should exit 0"
sh "$MA" bogus >/dev/null 2>&1  && fail "unknown subcommand should exit nonzero"

# install arg validation (use a throwaway MA_ROOT so set_prefix is happy)
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
printf 'MA_ROOT=%s/ma\nBUILD_DIR=%s/b\nSOURCE_DIR=%s/s\n' "$T" "$T" "$T" > "$T/cfg"
export MAINSTALLER_CONFIG="$T/cfg"
sh "$TOP/setup/setup.sh" >/dev/null 2>&1

sh "$MA" install >/dev/null 2>&1                && fail "install w/o app should fail"
sh "$MA" install no_such_app >/dev/null 2>&1    && fail "install unknown app should fail"
sh "$MA" install hphi no_such_mode >/dev/null 2>&1 && fail "install bad mode should fail"

# --- fixture repo: appF -> tF2 -> tF1  (fake install.sh/link.sh) ---
REPO=$(mktemp -d)
mk_pkg() { # <kind> <name> <requires-var-line> ; creates trivial install/link
  d="$REPO/$1/$2"; mkdir -p "$d/config/default"
  { printf '__NAME__=%s\n__VERSION__=1.0\n__MA_REVISION__=1\n' "$2"
    [ -n "${3:-}" ] && printf '%s\n' "$3"; } > "$d/version.sh"
  # install.sh: record order, create the versioned prefix + vars file;
  # abort like the real install.sh scripts ("Error: <prefix> exists") if
  # the versioned prefix is already there, instead of silently succeeding.
  cat > "$d/install.sh" <<EOS
#!/bin/sh
. "\$(cd "\$(dirname "\$0")"/../../scripts; pwd)/util.sh"
set_prefix
PREFIX="\$MA_ROOT/$2/$2-1.0-1"
if [ -d "\$PREFIX" ]; then
  echo "Error: \$PREFIX exists" >&2
  exit 127
fi
echo "$2" >> "\$MA_ROOT/build-order.log"
mkdir -p "\$PREFIX"
: > "\$MA_ROOT/$2/${2}vars-1.0-1.sh"
EOS
  # link.sh: for tools, create env.d marker (mirrors real tools' link.sh)
  cat > "$d/link.sh" <<EOS
#!/bin/sh
. "\$(cd "\$(dirname "\$0")"/../../scripts; pwd)/util.sh"
set_prefix
if [ "$1" = tools ]; then
  mkdir -p "\$MA_ROOT/env.d"
  ln -sf "\$MA_ROOT/$2/${2}vars-1.0-1.sh" "\$MA_ROOT/env.d/${2}vars.sh"
fi
EOS
}
cp -r "$TOP/scripts" "$REPO/scripts"
cp "$TOP/ma.sh" "$REPO/ma.sh"
mkdir -p "$REPO/setup"; cp "$TOP/setup/setup.sh" "$REPO/setup/setup.sh"
cp -r "$TOP/setup/config" "$REPO/setup/config"
mk_pkg tools tF1 ""
mk_pkg tools tF2 'TF2_REQUIRES="tF1"'
mk_pkg apps  appF 'APPF_REQUIRES="tF2"'

RT=$(mktemp -d)
printf 'MA_ROOT=%s/ma\nBUILD_DIR=%s/b\nSOURCE_DIR=%s/s\n' "$RT" "$RT" "$RT" > "$RT/cfg"
env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/setup/setup.sh" >/dev/null 2>&1

# first install: builds tF1, tF2, then appF, in order
env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/ma.sh" install appF >/dev/null 2>&1 \
  || fail "ma install appF should succeed"
got=$(tr '\n' ' ' < "$RT/ma/build-order.log")
[ "$got" = "tF1 tF2 appF " ] || fail "build order expected 'tF1 tF2 appF ' got '$got'"

# re-run: tools already available -> only appF would rebuild, but its prefix
# exists so install.sh aborts (mirrors the real install.sh's
# "Error: <prefix> exists" guard); ma should stop nonzero at the app step,
# WITHOUT rebuilding tF1/tF2 (order log unchanged for tools)
if env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/ma.sh" install appF >/dev/null 2>&1; then
  fail "re-run install appF should fail at the app step (prefix already exists)"
fi
got2=$(grep -c '^tF1$' "$RT/ma/build-order.log")
[ "$got2" = "1" ] || fail "tF1 must not be rebuilt on re-run (got $got2)"

# partial tool: remove tF1 marker but keep its prefix -> ma aborts with guidance
rm -f "$RT/ma/env.d/tF1vars.sh"; rm -rf "$RT/ma/appF"   # let appF pass, block on tF1
out=$(env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/ma.sh" install appF 2>&1)
echo "$out" | grep -q "partially installed" || fail "partial tF1 should report 'partially installed'"
rm -rf "$REPO" "$RT"

# list: shows apps and tools; marks apps with deps
lst=$(sh "$MA" list 2>/dev/null) || fail "list should exit 0"
echo "$lst" | grep -q "hphi" || fail "list should include hphi"

# (Task 6 fixture for the [deps] marker)
DT=$(mktemp -d); mkdir -p "$DT/apps/withdeps/config/default" "$DT/apps/nodeps/config/default" "$DT/tools"
printf '__NAME__=withdeps\nWITHDEPS_VERSION=1\nWITHDEPS_REQUIRES="x"\n' > "$DT/apps/withdeps/version.sh"
printf '__NAME__=nodeps\nNODEPS_VERSION=1\n' > "$DT/apps/nodeps/version.sh"
mkdir -p "$DT/tools/x"; printf '__NAME__=x\nX_VERSION=1\n' > "$DT/tools/x/version.sh"
cp -r "$TOP/scripts" "$DT/scripts"; cp "$TOP/ma.sh" "$DT/ma.sh"
dlst=$(sh "$DT/ma.sh" list 2>/dev/null)
echo "$dlst" | grep -E "withdeps.*\[deps\]" >/dev/null || fail "withdeps should be [deps]"
echo "$dlst" | grep "nodeps" | grep -q "\[deps\]" && fail "nodeps must not be [deps]"
rm -rf "$DT"

# installed: reports tools (env.d) and apps (<app>/<app>vars.sh)
IT=$(mktemp -d)
printf 'MA_ROOT=%s/ma\nBUILD_DIR=%s/b\nSOURCE_DIR=%s/s\n' "$IT" "$IT" "$IT" > "$IT/cfg"
env MAINSTALLER_CONFIG="$IT/cfg" sh "$TOP/setup/setup.sh" >/dev/null 2>&1
# tool 'cmake' registers via env.d marker; app 'bar' via <app>/<app>vars.sh
mkdir -p "$IT/ma/env.d" "$IT/ma/cmake" "$IT/ma/bar"
: > "$IT/ma/cmake/cmakevars-1.0-1.sh"
ln -sf "$IT/ma/cmake/cmakevars-1.0-1.sh" "$IT/ma/env.d/cmakevars.sh"
: > "$IT/ma/bar/barvars-2.0-1.sh"
ln -sf "$IT/ma/bar/barvars-2.0-1.sh" "$IT/ma/bar/barvars.sh"
inst=$(env MAINSTALLER_CONFIG="$IT/cfg" sh "$MA" installed 2>/dev/null) || fail "installed should exit 0"
echo "$inst" | grep -q "cmake" || fail "installed should list tool cmake (env.d)"
echo "$inst" | grep -q "bar"   || fail "installed should list app bar (<app>vars)"
rm -rf "$IT"

echo "$(sh "$MA" list 2>/dev/null)" | grep -E "hphi .*\[deps\]" >/dev/null \
  || fail "hphi should be marked [deps]"

[ "$FAILED" -eq 0 ] && echo "ALL TESTS PASSED"
exit "$FAILED"
