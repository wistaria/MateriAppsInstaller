#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/../../scripts/util.sh
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/version.sh
set_prefix

URL=https://github.com/Einsums/Einsums/archive/refs/tags/v"$__VERSION__".tar.gz
ARCHIVE="$SOURCE_DIR"/"$__NAME__"-"$__VERSION__".tar.gz

if [ -f "$ARCHIVE" ]; then :; else
  check wget "$URL" -O "$ARCHIVE"
fi
