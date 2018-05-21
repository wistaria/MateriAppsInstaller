#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR

## TRIQS
if [ -d triqs-$TRIQS_VERSION ]; then :; else
  if [ -f triqs-$TRIQS_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/triqs-$TRIQS_VERSION.tar.gz .
    else
      check wget -O triqs-$TRIQS_VERSION.tar.gz https://github.com/TRIQS/triqs/archive/$TRIQS_VERSION.tar.gz
    fi
  fi
  check mkdir -p triqs-$TRIQS_VERSION
  check tar zxf triqs-$TRIQS_VERSION.tar.gz -C triqs-$TRIQS_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch ]; then
    cd triqs-$TRIQS_VERSION
    patch -p1 < $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch
  fi
fi

## TRIQS_DFTTools
if [ -d triqs-dfttools-$TRIQS_DFTTOOLS_VERSION ]; then :; else
  git clone https://github.com/TRIQS/dft_tools triqs-dfttools-$TRIQS_DFTTOOLS_VERSION
  cd triqs-dfttools-$TRIQS_DFTTOOLS_VERSION
  git checkout $TRIQS_DFTTOOLS_VERSION
fi

## TRIQS-CTHYB
if [ -d triqs-cthyb-$TRIQS_CTHYB_VERSION ]; then :; else
  if [ -f triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz .
    else
      check wget -O triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz https://github.com/TRIQS/cthyb/archive/$TRIQS_CTHYB_VERSION.tar.gz
    fi
  fi
  check mkdir -p triqs-cthyb-$TRIQS_CTHYB_VERSION
  check tar zxf triqs-cthyb-$TRIQS_CTHYB_VERSION.tar.gz -C triqs-cthyb-$TRIQS_CTHYB_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/triqs-$TRIQS_CTHYB_VERSION.patch ]; then
    cd triqs-cthyb-$TRIQS_CTHYB_VERSION
    patch -p1 < $SCRIPT_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION.patch
  fi
fi

## TRIQS-HubbardI
if [ -d triqs-hubbardI-$TRIQS_HUBBARDI_VERSION ]; then :; else
  git clone https://github.com/TRIQS/hubbardI triqs-hubbardI-$TRIQS_HUBBARDI_VERSION
  cd triqs-hubbardI-$TRIQS_HUBBARDI_VERSION
  git checkout $TRIQS_HUBBARDI_VERSION
fi

