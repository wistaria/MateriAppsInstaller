#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/hphi-$HPHI_VERSION.tar.gz ]; then :; else
  check wget https://github.com/issp-center-dev/hphi/releases/download/v${HPHI_VERSION}/HPhi-${HPHI_VERSION}.tar.gz -O $SOURCE_DIR/hphi-${HPHI_VERSION}.tar.gz
fi
