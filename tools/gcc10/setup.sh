#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix
sh ${SCRIPT_DIR}/download.sh

NV=${__NAME__}-${__VERSION__}
cd $BUILD_DIR
if [ -d ${NV} ]; then :; else
  check tar zxf $SOURCE_DIR/$NV.tar.gz
  cd $NV
  check tar jxf $SOURCE_DIR/gmp-${GMP_VERSION}.tar.bz2
  mv gmp-${GMP_VERSION} gmp
  check tar jxf $SOURCE_DIR/mpfr-${MPFR_VERSION}.tar.bz2
  mv mpfr-${MPFR_VERSION} mpfr
  check tar zxf $SOURCE_DIR/mpc-${MPC_VERSION}.tar.gz
  mv mpc-${MPC_VERSION} mpc
  check tar jxf $SOURCE_DIR/isl-$ISL_VERSION.tar.bz2
  mv isl-$ISL_VERSION isl
  if [ -f $SCRIPT_DIR/patch/${NV}.patch ]; then
    cat $SCRIPT_DIR/patch/${NV}.patch | patch -p1
  fi
fi
