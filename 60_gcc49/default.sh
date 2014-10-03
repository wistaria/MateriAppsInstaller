#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

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

cd $BUILD_DIR
rm -rf gcc-$GCC_VERSION-build
mkdir gcc-$GCC_VERSION-build
cd gcc-$GCC_VERSION-build
check $BUILD_DIR/gcc-$GCC_VERSION/configure --enable-languages=c,c++,fortran --prefix=$PREFIX_OPT/gcc-$GCC_VERSION --disable-multilib
check make -j4
$SUDO make install
$SUDO rm -f $PREFIX/gcc-$GCC_VERSION_MAJOR
$SUDO ln -s gcc-$GCC_VERSION $PREFIX/gcc-$GCC_VERSION_MAJOR
cat << EOF > gcc-$GCC_VERSION.sh
export PATH=$PREFIX_OPT/gcc-$GCC_VERSION/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_OPT/gcc-$GCC_VERSION/lib64:\$LD_LIBRARY_PATH
EOF
$SUDO cp gcc-$GCC_VERSION.sh $PREFIX/gcc-$GCC_VERSION.sh
$SUDO rm -f $PREFIX/gcc-$GCC_VERSION_MAJOR.sh
$SUDO ln -s gcc-$GCC_VERSION.sh $PREFIX/gcc-$GCC_VERSION_MAJOR.sh
