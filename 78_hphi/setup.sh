#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d hphi-$HPHI_VERSION ]; then :; else
  check mkdir -p hphi-$HPHI_VERSION
  if [ -f $SOURCE_DIR/hphi-$HPHI_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/hphi-$HPHI_VERSION.tar.gz -C hphi-$HPHI_VERSION --strip-components=2
  else
    if [ -f hphi-$HPHI_VERSION.tar.gz ]; then :; else
      check wget https://github.com/issp-center-dev/hphi/releases/download/v${HPHI_VERSION}/HPhi-${HPHI_VERSION}.tar.gz -O hphi-${HPHI_VERSION}.tar.gz
    fi
    check tar zxf hphi-${HPHI_VERSION}.tar.gz -C hphi-$HPHI_VERSION --strip-components=2
  fi
fi
