#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/lapack-$LAPACK_VERSION-$LAPACK_MA_REVISION.log
PREFIX=$PREFIX_TOOL/lapack/lapack-$LAPACK_VERSION-$LAPACK_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/lapack-$LAPACK_VERSION
cat << EOF > make.inc
FORTRAN  = gfortran
OPTS     = -O3 \$(PIC)
NOOPT    = -O0 \$(PIC)
DRVOPTS  = \$(OPTS)
LOADER   = gfortran
LOADOPTS =
TIMER    = INT_ETIME
BLASLIB  = ../../libblas.\$(LIBSFX)
LAPACKLIB= liblapack.\$(LIBSFX)
TMGLIB= libtmg.\$(LIBSFX)
EOF
echo "[make static libraries]" | tee -a $LOG
check make ARCH="ar" ARCHFLAGS="cr" RANLIB=ranlib LIBSFX=a blaslib lapacklib -j4 | tee -a $LOG
check make ARCH="ar" ARCHFLAGS="cr" RANLIB=ranlib LIBSFX=a blas_testing lapack_testing -j4 | tee -a $LOG
check make clean | tee -a $LOG
echo "[make dynamic libraries]" | tee -a $LOG
check make PIC=-fPIC ARCH="gcc -shared" ARCHFLAGS="-o" RANLIB=/bin/true LIBSFX=so blaslib lapacklib -j4 | tee -a $LOG
check mkdir -p $PREFIX_FRONTEND/lib
check cp -p libblas.* liblapack.* $PREFIX_FRONTEND/lib

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
rm -f $LAPACKVARS_SH
cp -f $BUILD_DIR/lapackvars.sh $LAPACKVARS_SH
rm -f $BUILD_DIR/lapackvars.sh
cp -f $LOG $PREFIX_TOOL/lapack/
