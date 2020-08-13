#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d mVMC-$MVMC_VERSION ]; then :; else
  check mkdir -p mvmc-$MVMC_VERSION
  tarfile=$SOURCE_DIR/mVMC-$MVMC_VERSION.tar.gz
  sc=$(calc_strip_components $tarfile README.md)
  check tar zxf $tarfile -C mvmc-$MVMC_VERSION --strip-components=$sc
  cd mvmc-$MVMC_VERSION
  if [ -f $SCRIPT_DIR/patch/mvmc-$MVMC_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/mvmc-$MVMC_VERSION.patch
  fi
fi
