#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR

## Alpscore_CTHYB_CTHYB
if [ -d alpscore-cthyb-$ALPSCORE_CTHYB_VERSION ]; then :; else
  check mkdir -p alpscore-cthyb-$ALPSCORE_CTHYB_VERSION
  check tar zxf $SOURCE_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz -C alpscore-cthyb-$ALPSCORE_CTHYB_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.patch ]; then
    cd alpscore-cthyb-$ALPSCORE_CTHYB_VERSION
    patch -p1 < $SCRIPT_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.patch
  fi
fi

## Alpscore-CTHYB-TRIQS-interface
if [ -d alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION ]; then :; else
  check mkdir -p alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
  check tar zxf $SOURCE_DIR/alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION.tar.gz -C alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION.patch ]; then
    cd alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION
    patch -p1 < $SCRIPT_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION.patch
  fi
fi
