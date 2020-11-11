#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR

## TRIQS
if [ -f $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz https://github.com/TRIQS/triqs/archive/$TRIQS_VERSION.tar.gz
fi

## TRIQS_DFTTools
if [ -f $SOURCE_DIR/triqs-dfttools-$TRIQS_DFTTOOLS_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/triqs-dfttools-$TRIQS_DFTTOOLS_VERSION.tar.gz https://github.com/TRIQS/dft_tools/archive/$TRIQS_DFTTOOLS_VERSION.tar.gz
fi

## TRIQS-CTHYB
if [ -f $SOURCE_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz https://github.com/TRIQS/cthyb/archive/$TRIQS_CTHYB_VERSION.tar.gz
fi

## TRIQS-HubbardI
if [ -f $SOURCE_DIR/triqs-hubbardI-$TRIQS_HUBBARDI_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/triqs-hubbardI-$TRIQS_HUBBARDI_VERSION.tar.gz https://github.com/TRIQS/hubbardI/archive/$TRIQS_HUBBARDI_VERSION.tar.gz
fi
