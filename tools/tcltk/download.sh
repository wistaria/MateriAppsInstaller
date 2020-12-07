#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

for m in tcl tk; do
  if [ -f $SOURCE_DIR/${m}${__VERSION__}-src.tar.gz ]; then :; else
    check wget -O $SOURCE_DIR/${m}${__VERSION__}-src.tar.gz https://prdownloads.sourceforge.net/tcl/${m}${__VERSION__}-src.tar.gz
  fi
done
