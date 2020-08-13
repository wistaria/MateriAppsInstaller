#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR

## TRIQS
if [ -d triqs-$TRIQS_VERSION ]; then :; else
  check mkdir -p triqs-$TRIQS_VERSION
  check tar zxf $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz -C triqs-$TRIQS_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch ]; then
    cd triqs-$TRIQS_VERSION
    patch -p1 < $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch
  fi
fi

## TRIQS-DFTTools
if [ -d triqs-dfttools-$TRIQS_DFTTOOLS_VERSION ]; then :; else
  check mkdir -p triqs-dfttools-$TRIQS_DFTTOOLS_VERSION
  check tar zxf $SOURCE_DIR/triqs-dfttools-$TRIQS_DFTTOOLS_VERSION.tar.gz -C triqs-dfttools-$TRIQS_DFTTOOLS_VERSION --strip-components=1
fi

## TRIQS-CTHYB
if [ -d triqs-cthyb-$TRIQS_CTHYB_VERSION ]; then :; else
  check mkdir -p triqs-cthyb-$TRIQS_CTHYB_VERSION
  check tar zxf $SOURCE_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz -C triqs-cthyb-$TRIQS_CTHYB_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/triqs-$TRIQS_CTHYB_VERSION.patch ]; then
    cd triqs-cthyb-$TRIQS_CTHYB_VERSION
    patch -p1 < $SCRIPT_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.patch
  fi
fi

## TRIQS-HubbardI
if [ -d triqs-hubbardI-$TRIQS_HUBBARDI_VERSION ]; then :; else
  check mkdir -p triqs-hubbardI-$TRIQS_HUBBARDI_VERSION
  check tar zxf $SOURCE_DIR/triqs-hubbardI-$TRIQS_HUBBARDI_VERSION.tar.gz -C triqs-hubbardI-$TRIQS_HUBBARDI_VERSION --strip-components=1
fi
