#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d hphi-$HPHI_VERSION ]; then :; else
  check mkdir -p hphi-$HPHI_VERSION
  check tar zxf $SOURCE_DIR/hphi-$HPHI_VERSION.tar.gz -C hphi-$HPHI_VERSION --strip-components=2
  cd hphi-$HPHI_VERSION
  if [ -f $SCRIPT_DIR/hphi-$HPHI_VERSION.patch ]; then
    patch -p1 < $SCRIPT_DIR/hphi-$HPHI_VERSION.patch
  fi
fi
