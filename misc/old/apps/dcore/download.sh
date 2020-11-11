#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/dcore-$DCORE_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/dcore-$DCORE_VERSION.tar.gz https://github.com/issp-center-dev/DCore/archive/v$DCORE_VERSION.tar.gz
fi
