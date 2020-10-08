#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__}-${__MA_REVISION__} ]; then :; else
  rm -rf ${__NAME__}-${__VERSION__}
  check tar zxf $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
  mv ${__NAME__}-${__VERSION__} ${__NAME__}-${__VERSION__}-${__MA_REVISION__}
  cd ${__NAME__}-${__VERSION__}-${__MA_REVISION__}
  check tar jxf $SOURCE_DIR/gmp-${GMP_VERSION}.tar.bz2
  mv gmp-${GMP_VERSION} gmp
  check tar jxf $SOURCE_DIR/mpfr-${MPFR_VERSION}.tar.bz2
  mv mpfr-${MPFR_VERSION} mpfr
  check tar zxf $SOURCE_DIR/mpc-${MPC_VERSION}.tar.gz
  mv mpc-${MPC_VERSION} mpc
  check tar jxf $SOURCE_DIR/isl-$ISL_VERSION.tar.bz2
  mv isl-$ISL_VERSION isl
fi
