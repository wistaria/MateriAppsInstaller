#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

URL=https://github.com/issp-center-dev/H-wave/archive/refs/tags/v${__VERSION__}.tar.gz
ARCHIVE=${SOURCE_DIR}/${__NAME__}-${__VERSION__}.tar.gz

if [ -f $ARCHIVE ]; then :; else
  check wget $URL -O $ARCHIVE
fi

URL=https://isspns-gitlab.issp.u-tokyo.ac.jp/hwave-dev/hwave-gallery/-/archive/main/hwave-gallery-main.tar.gz
ARCHIVE=${SOURCE_DIR}/hwave-gallery-main.tar.gz

if [ -f $ARCHIVE ]; then :; else
  check wget $URL -O $ARCHIVE
fi
