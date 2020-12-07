#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}_${__VERSION_UNDERSCORE__}.tar.bz2 ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}_${__VERSION_UNDERSCORE__}.tar.bz2 http://sourceforge.net/projects/${__NAME__}/files/${__NAME__}/${__VERSION__}/${__NAME__}_${__VERSION_UNDERSCORE__}.tar.bz2/download
fi
