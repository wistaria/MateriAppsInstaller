#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/alpscore-$ALPSCORE_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/alpscore-$ALPSCORE_VERSION.tar.gz https://github.com/ALPSCore/ALPSCore/archive/v$ALPSCORE_VERSION.tar.gz
fi
