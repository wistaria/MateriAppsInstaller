#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

FILE="alpscore-${__VERSION__}.tar.gz"
if [ -f $SOURCE_DIR/$FILE ]; then :; else
  check wget -O $SOURCE_DIR/$FILE $WGET_OPTION https://github.com/ALPSCore/ALPSCore/archive/v${__VERSION__}.tar.gz
fi
