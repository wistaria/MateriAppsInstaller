#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ "_${USE_RELEASED}" = "_ON" ]; then
  URL=https://github.com/TRIQS/triqs/archive/${__VERSION__}.tar.gz
  FILE="${__NAME__}-${__VERSION__}.tar.gz"
else
  URL=https://github.com/TRIQS/triqs/archive/${TRIQS_SHA}.zip
  FILE=${__NAME__}-${__VERSION__}.zip
fi

if [ -f $SOURCE_DIR/$FILE ]; then :; else
  check wget -O $SOURCE_DIR/$FILE $WGET_OPTION $URL
fi
