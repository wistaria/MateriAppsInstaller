#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

## Alpscore_CTHYB_CTHYB
if [ -f $SOURCE_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/alpscore-cthyb-$ALPSCORE_CTHYB_VERSION.tar.gz https://github.com/ALPSCore/CT-HYB/archive/$ALPSCORE_CTHYB_VERSION.tar.gz
fi

## Alpscore-CTHYB-TRIQS-interface
if [ -f $SOURCE_DIR/alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/alpscore-cthyb-triqs-interface-$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION.tar.gz https://github.com/shinaoka/triqs_interface/archive/$ALPSCORE_CTHYB_TRIQS_INTERFACE_VERSION.tar.gz
fi
