#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/lapack/lapack-$LAPACK_VERSION-$LAPACK_PATCH_VERSION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"

cd $BUILD_DIR
rm -rf BLAS
if [ -f $HOME/source/blas.tgz ]; then
  check tar zxf $HOME/source/blas.tgz
else
  check wget -O - http://www.netlib.org/blas/blas.tgz | tar zxf -
fi

cd $BUILD_DIR/BLAS
check make FORTRAN=gfortran BLASLIB=libblas.a ARCH=ar ARCHFLAGS=cr -j4
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p libblas.a $PREFIX_FRONTEND/lib
check make clean
check make FORTRAN=gfortran OPTS="-O3 -fPIC" BLASLIB=libblas.so ARCH="gcc -shared" ARCHFLAGS=-o RANLIB=/bin/true -j4
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p libblas.so $PREFIX_FRONTEND/lib

cd $BUILD_DIR
rm -rf lapack-$LAPACK_VERSION
if [ -f $HOME/source/lapack-$LAPACK_VERSION.tgz ]; then
  check tar zxf $HOME/source/lapack-$LAPACK_VERSION.tgz
else
  check wget -O - http://www.netlib.org/lapack/lapack-$LAPACK_VERSION.tgz | tar zxf -
fi

cd $BUILD_DIR/lapack-$LAPACK_VERSION
cat << EOF > make.inc
FORTRAN  = gfortran
DRVOPTS  = \$(OPTS)
LOADER   = gfortran
LOADOPTS =
TIMER    = INT_ETIME
EOF
check make OPTS="-O3" NOOPT="-O0" ARCH="ar" ARCHFLAGS="cr" RANLIB=ranlib LAPACKLIB=liblapack.a lapacklib -j4
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p liblapack.a $PREFIX_FRONTEND/lib
check make clean
check make OPTS="-O3 -fPIC" NOOPT="-O0 -fPIC" ARCH="gcc -shared" ARCHFLAGS="-o" RANLIB=/bin/true LAPACKLIB=liblapack.so lapacklib -j4
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p liblapack.so $PREFIX_FRONTEND/lib

cat << EOF > $BUILD_DIR/lapackvars.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
export LAPACK_ROOT=$PREFIX
export LD_LIBRARY_PATH=\$LAPACK_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
LAPACKVARS_SH=$PREFIX_TOOL/lapack/lapackvars-$LAPACK_VERSION-$LAPACK_PATCH_VERSION.sh
$SUDO_TOOL rm -f $LAPACKVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/lapackvars.sh $LAPACKVARS_SH
