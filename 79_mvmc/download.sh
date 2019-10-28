#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/mVMC-$MVMC_VERSION.tar.gz ]; then :; else
  check wget https://github.com/issp-center-dev/mVMC/releases/download/v${MVMC_VERSION}/mVMC-${MVMC_VERSION}.tar.gz -O $SOURCE_DIR/mVMC-${MVMC_VERSION}.tar.gz
fi
