#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/../../scripts/util.sh
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/version.sh
set_prefix

# shellcheck disable=SC1091
. "$MA_ROOT"/env.sh

VARS_SH="$MA_ROOT"/"$__NAME__"/"$__NAME__"vars-"$__VERSION__"-"$__MA_REVISION__".sh
rm -f "$MA_ROOT"/env.d/"$__NAME__"vars.sh
ln -s "$VARS_SH" "$MA_ROOT"/env.d/"$__NAME__"vars.sh
