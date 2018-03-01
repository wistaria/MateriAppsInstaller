#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d quantum-espresso-$QUANTUM_ESPRESSO_VERSION ]; then :; else
  if [ -f quantum-espresso-$QUANTUM_ESPRESSO_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/quantum-espresso-$QUANTUM_ESPRESSO_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/quantum-espresso_$QUANTUM_ESPRESSO_VERSION.tar.gz .
    else
      check wget -O quantum-espresso-$QUANTUM_ESPRESSO_VERSION.tar.gz $WGET_OPTION http://quantum-espresso-forge.org/gf/download/frsrelease/$QUANTUM_ESPRESSO_DOWNLOAD_DIR/quantum-espresso-$QUANTUM_ESPRESSO_VERSION.tar.gz
    fi
  fi
  check mkdir -p quantum-espresso-$QUANTUM_ESPRESSO_VERSION
  check tar zxf quantum-espresso-$QUANTUM_ESPRESSO_VERSION.tar.gz -C quantum-espresso-$QUANTUM_ESPRESSO_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/quantum-espresso-$QUANTUM_ESPRESSO_VERSION.patch ]; then
    cd quantum-espresso-$QUANTUM_ESPRESSO_VERSION
    patch -p1 < $SCRIPT_DIR/quantum-espresso-$QUANTUM_ESPRESSO_VERSION.patch
  fi
fi
