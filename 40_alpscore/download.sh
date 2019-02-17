#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

FILE="alpscore_$ALPSCORE_VERSION.orig.tar.gz"
if [ -f $SOURCE_DIR/$FILE ]; then :; else
  check wget -O $SOURCE_DIR/$FILE $MALIVE_REPOSITORY/$FILE
fi
