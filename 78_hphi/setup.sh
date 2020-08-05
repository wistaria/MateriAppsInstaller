#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d hphi-$HPHI_VERSION ]; then :; else
  check mkdir -p hphi-$HPHI_VERSION
  tarfile=$SOURCE_DIR/hphi-$HPHI_VERSION.tar.gz
  sc=`calc_strip_components $tarfile README.md`
  check tar zxf $tarfile -C hphi-$HPHI_VERSION --strip-components=$sc
  cd hphi-$HPHI_VERSION
  if [ -f $SCRIPT_DIR/patch/hphi-$HPHI_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/hphi-$HPHI_VERSION.patch
  fi
fi
