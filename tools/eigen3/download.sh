#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.bz2 ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.bz2 https://gitlab.com/libeigen/eigen/-/archive/${__VERSION__}/eigen-${__VERSION__}.tar.bz2
fi
