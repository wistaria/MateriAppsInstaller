#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d HPhi-$HPHI_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/HPhi-release-$HPHI_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/HPhi_$HPHI_VERSION.tar.gz
  else
    if [ -f HPhi-release-$HPhi_VERSION.tar.gz ]; then :; else
      check wget https://github.com/QLMS/HPhi/releases/download/v${HPHI_VERSION}/HPhi-release-${HPHI_VERSION}.tar.gz -O HPhi-release-${HPHI_VERSION}.tar.gz
    fi
    check tar zxf HPhi-release-${HPHI_VERSION}.tar.gz
  fi
  cd HPhi-release-${HPHI_VERSION}
  cp doc/userguide_jp.pdf .
  cp doc/userguide_en.pdf .
fi
