#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d mVMC-$MVMC_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/mVMC-$MVMC_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/mVMC-$MVMC_VERSION.tar.gz
  else
    if [ -f mVMC-$mVMC_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/mVMC/releases/download/v${MVMC_VERSION}/mVMC-${MVMC_VERSION}.tar.gz -O mVMC-${MVMC_VERSION}.tar.gz
    fi
    check tar zxf mVMC-${MVMC_VERSION}.tar.gz
  fi
  cd mVMC-${MVMC_VERSION}
  cp doc/jp/userguide_jp.pdf .
  cp doc/en/userguide_en.pdf .
fi
