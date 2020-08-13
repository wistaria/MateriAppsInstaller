#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

FILE=qe-$ESPRESSO_VERSION.tar.gz
if [ -f $SOURCE_DIR/$FILE ]; then :; else
  check wget -O $SOURCE_DIR/$FILE $WGET_OPTION https://github.com/QEF/q-e/releases/download/qe-$ESPRESSO_VERSION/$FILE
fi
