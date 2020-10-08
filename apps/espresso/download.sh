#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

FILE=qe-${__VERSION__}.tar.gz
if [ -f $SOURCE_DIR/$FILE ]; then :; else
  check wget -O $SOURCE_DIR/$FILE https://github.com/QEF/q-e/archive/qe-${__VERSION__}/$FILE
fi
