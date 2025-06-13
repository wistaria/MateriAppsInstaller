#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/../../scripts/util.sh
# shellcheck disable=SC1091
. "$SCRIPT_DIR"/version.sh
set_prefix
sh "$SCRIPT_DIR"/download.sh

cd "$BUILD_DIR" || exit
NV=${__NAME__}-${__VERSION__}
if [ -d "$NV" ]; then :; else
  check mkdir -p "$NV"
  tar -xvf "$SOURCE_DIR"/"$NV".tar.gz -C "$NV" --strip-components=1
  if [ -f "$SCRIPT_DIR"/patch/"$NV".patch ]; then
    patch -p1 < "$SCRIPT_DIR"/patch/"$NV".patch
  fi
fi
