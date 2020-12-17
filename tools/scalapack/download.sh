#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tgz ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tgz http://www.netlib.org/${__NAME__}/${__NAME__}-${__VERSION__}.tgz
fi
