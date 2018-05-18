#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR

## Alpscore_CTHYB_CTHYB
if [ -d alpscore-cthyb-$ALPSCORE_CTHYB_VERSION ]; then :; else
  if [ -f alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz .
    else
      check wget -O alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz https://github.com/ALPSCore/CT-HYB/archive/$ALPSCORE_CTHYB_VERSION.tar.gz
    fi
  fi
  rm -rf alpscore-cthyb-$ALPSCORE_CTHYB_VERSION
  check mkdir -p alpscore-cthyb-$ALPSCORE_CTHYB_VERSION
  check tar zxf alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz -C alpscore-cthyb-$ALPSCORE_CTHYB_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.patch ]; then
    cd alpscore-cthyb-$ALPSCORE_CTHYB_VERSION
    patch -p1 < $SCRIPT_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.patch
  fi
fi

## Alpscore-CTHYB-TRIQS-interface
if [ -d alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION ]; then :; else
  git clone https://github.com/shinaoka/triqs_interface alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
  cd alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
  git checkout $ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
fi



