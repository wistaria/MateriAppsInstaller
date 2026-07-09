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

[ "$FAILED" -eq 0 ] && echo "ALL TESTS PASSED"
exit "$FAILED"
