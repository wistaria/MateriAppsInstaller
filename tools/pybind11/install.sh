#!/bin/sh

cat << EOF > config.txt
# configurable variables (e.g. compiler)

# use default if not defined
export CMAKE="${CMAKE:-cmake}"
export MA_EXTRA_FLAGS="${MA_EXTRA_FLAGS:-""}"

# export explicitly if defined
test -n "${CC+defined}" && export CXX="$CC"
test -n "${CXX+defined}" && export CXX="$CXX"
EOF
# shellcheck disable=SC1091
. ./config.txt

set -e

XTRACED=$(set -o | awk '/xtrace/{ print $2 }')
if [ "$XTRACED" = "on" ]; then
  SHFLAG="-x"
fi

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Error: unknown mode: $mode"
  echo "Available list:"
  ls -1 "$SCRIPT_DIR"/config
  exit 127
fi
DEFAULT_CONFIG_DIR="$SCRIPT_DIR"/config/default

export UTIL_SH="$SCRIPT_DIR"/../../scripts/util.sh
# shellcheck disable=SC1090
. "$UTIL_SH"
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/version.sh
set_prefix

# shellcheck disable=SC1091
. "$MA_ROOT"/env.sh
export PREFIX="$MA_ROOT"/"$__NAME__"/"$__NAME__"-"$__VERSION__"-"$__MA_REVISION__"
if [ -d "$PREFIX" ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi
export LOG="$BUILD_DIR"/"$__NAME__"-"$__VERSION__"-"$__MA_REVISION__".log
mv config.txt "$LOG"
echo "mode = $mode" | tee -a "$LOG"

rm -rf "$BUILD_DIR"/"$__NAME__"-"$__VERSION__"
pipefail check sh "$SHFLAG" "$SCRIPT_DIR"/setup.sh \| tee -a "$LOG"
cd "$BUILD_DIR"/"$__NAME__"-"$__VERSION__"
start_info | tee -a "$LOG"

for process in preprocess build install postprocess; do
  if [ -f "$CONFIG_DIR"/"$process".sh ]; then
    echo "[${process}]" | tee -a "$LOG"
    pipefail check sh "$SHFLAG" "$CONFIG_DIR"/"$process".sh \| tee -a "$LOG"
  elif [ -f "$DEFAULT_CONFIG_DIR"/"$process".sh ]; then
    echo "[${process}]" | tee -a "$LOG"
    pipefail check sh "$SHFLAG" "$DEFAULT_CONFIG_DIR"/"$process".sh \| tee -a "$LOG"
  fi
done

finish_info | tee -a "$LOG"

ROOTNAME=$(toupper "$__NAME__")_ROOT

cat << EOF > "$BUILD_DIR"/"$__NAME__"vars.sh
# $__NAME__ $mode $__VERSION__ $__MA_REVISION__ $(date +%Y%m%d-%H%M%S)
export ${ROOTNAME}="$PREFIX"
EOF
VARS_SH="$MA_ROOT"/"$__NAME__"/"$__NAME__"vars-"$__VERSION__"-"$__MA_REVISION__".sh
rm -f "$VARS_SH"
cp -f "$BUILD_DIR"/"$__NAME__"vars.sh "$VARS_SH"
cp -f "$LOG" "$MA_ROOT"/"$__NAME__"/
