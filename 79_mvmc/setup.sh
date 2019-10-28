#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d mVMC-$MVMC_VERSION ]; then :; else
  check mkdir -p mvmc-$MVMC_VERSION
  check tar zxf $SOURCE_DIR/mVMC-$MVMC_VERSION.tar.gz -C mvmc-$MVMC_VERSION --strip-components=1
  cd mvmc-$MVMC_VERSION
  if [ -f $SCRIPT_DIR/mvmc-$MVMC_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/mvmc-$MVMC_VERSION.patch
  fi
fi
