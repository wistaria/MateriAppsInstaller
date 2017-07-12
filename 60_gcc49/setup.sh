#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
rm -rf gcc-$GCC_VERSION
wget -O - http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2 | bzip2 -dc | tar xf -
cd gcc-$GCC_VERSION
wget -O - ftp://ftp.gnu.org/gnu/gmp/gmp-$GMP_VERSION.tar.bz2 | bzip2 -dc | tar xf -
mv gmp-$GMP_VERSION gmp
wget -O - http://www.mpfr.org/mpfr-$MPFR_VERSION/mpfr-$MPFR_VERSION.tar.bz2 | bzip2 -dc | tar xf -
mv mpfr-$MPFR_VERSION mpfr
wget -O - http://www.multiprecision.org/mpc/download/mpc-$MPC_VERSION.tar.gz | gzip -dc | tar xf -
mv mpc-$MPC_VERSION mpc
wget -O - ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-$ISL_VERSION.tar.bz2 | bzip2 -dc | tar xf -
mv isl-$ISL_VERSION isl
wget -O - ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-$CLOOG_VERSION.tar.gz | gzip -dc | tar xf -
mv cloog-$CLOOG_VERSION cloog
