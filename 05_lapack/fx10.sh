#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

$SUDO_TOOL /bin/true
. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/lapack-$LAPACK_VERSION-$LAPACK_MA_REVISION.log
PREFIX=$PREFIX_TOOL/lapack/lapack-$LAPACK_VERSION-$LAPACK_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/BLAS
start_info | tee -a $LOG
echo "[make BLAS static library]" | tee -a $LOG
check make FORTRAN=gfortran BLASLIB=libblas.a ARCH=ar ARCHFLAGS=cr -j4 | tee -a $LOG
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p libblas.a $PREFIX_FRONTEND/lib
check make clean
echo "[make BLAS dynamic library]" | tee -a $LOG
check make FORTRAN=gfortran OPTS="-O3 -fPIC" BLASLIB=libblas.so ARCH="gcc -shared" ARCHFLAGS=-o RANLIB=/bin/true -j4
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p libblas.so $PREFIX_FRONTEND/lib

cd $BUILD_DIR/lapack-$LAPACK_VERSION
cat << EOF > make.inc
FORTRAN  = gfortran
DRVOPTS  = \$(OPTS)
LOADER   = gfortran
LOADOPTS =
TIMER    = INT_ETIME
EOF
echo "[make LAPACK static library]" | tee -a $LOG
check make OPTS="-O3" NOOPT="-O0" ARCH="ar" ARCHFLAGS="cr" RANLIB=ranlib LAPACKLIB=liblapack.a lapacklib -j4 | tee -a $LOG
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p liblapack.a $PREFIX_FRONTEND/lib
check make clean
echo "[make LAPACK dynamic library]" | tee -a $LOG
check make OPTS="-O3 -fPIC" NOOPT="-O0 -fPIC" ARCH="gcc -shared" ARCHFLAGS="-o" RANLIB=/bin/true LAPACKLIB=liblapack.so lapacklib -j4
$SUDO_TOOL check mkdir -p $PREFIX_FRONTEND/lib
$SUDO_TOOL check cp -p liblapack.so $PREFIX_FRONTEND/lib

cat << EOF > $BUILD_DIR/lapackvars.sh
# lapack $(basename $0 .sh) $LAPACK_VERSION $LAPACK_MA_REVISION $(date +%Y%m%d-%H%M%S)
OS=\$(uname -s)
ARCH=\$(uname -m)
export LAPACK_ROOT=$PREFIX
export LAPACK_VERSION=$LAPACK_VERSION
export LAPACK_MA_REVISION=$LAPACK_MA_REVISION
export LD_LIBRARY_PATH=\$LAPACK_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
LAPACKVARS_SH=$PREFIX_TOOL/lapack/lapackvars-$LAPACK_VERSION-$LAPACK_MA_REVISION.sh
$SUDO_TOOL rm -f $LAPACKVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/lapackvars.sh $LAPACKVARS_SH
rm -f $BUILD_DIR/lapackvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/lapack/
