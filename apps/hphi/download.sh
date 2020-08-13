#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  _check wget https://github.com/issp-center-dev/hphi/releases/download/v${__VERSION__}/HPhi-${__VERSION__}.tar.gz -O $SOURCE_DIR/${__NAME__}-${__HPHI_VERSION__}.tar.gz
fi
