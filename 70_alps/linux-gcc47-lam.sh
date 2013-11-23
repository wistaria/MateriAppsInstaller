#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../03_boost/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh
. $PREFIX_OPT/gcc-4.7.sh

mkdir -p $PREFIX_ALPS/source $PREFIX_ALPS/script
check cp -p $0 $PREFIX_ALPS/script/compile-$ALPS_VERSION.sh
check cp -p $HOME/source/alps-$ALPS_VERSION.tar.gz $PREFIX_ALPS/source/

YMDT=`date +%Y%m%d%H%M%S`
LOG=$PREFIX_ALPS/script/compile-$ALPS_VERSION.$YMDT.log
rm -f $LOG
echo "LOG=$LOG"

echo "PREFIX=$PREFIX_ALPS" > $LOG
echo "ALPS_VERSION=$ALPS_VERSION" >> $LOG
echo "BOOST_VERSION=$BOOST_VERSION" >> $LOG
echo "SCRIPT=$PREFIX_ALPS/script/compile-$ALPS_VERSION.sh" >> $LOG
echo "LOG=$LOG" >> $LOG

(cd $BUILD_DIR && tar zxf $PREFIX_ALPS/source/alps-$ALPS_VERSION.tar.gz)

### OpenMP version

VERSION=$ALPS_VERSION
echo "[start alps-$VERSION]" >> $LOG 2>&1

rm -rf $BUILD_DIR/alps-build-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-$VERSION.$YMDT
echo "[cmake]" >> $LOG 2>&1
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$VERSION \
  -DCMAKE_C_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gcc" -DCMAKE_CXX_COMPILER="$PREFIX_OPT/gcc-4.7/bin/g++" -DCMAKE_Fortran_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gfortran" \
  -DMPIEXEC="/usr/lib64/lam/bin/mpirun" -DMPI_LIBRARY="/usr/lib64/lam/lib/libmpi.so;/usr/lib64/lam/lib/liblammpi++.so;/usr/lib64/lam/lib/liblam.so" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_VERSION -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON -DALPS_BUILD_FORTRAN=ON \
  -DBLAS_LIBRARY=-lblas -DLAPACK_LIBRARY=-llapack \
  $HOME/build/alps-$ALPS_VERSION >> $LOG 2>&1

echo "[make install]" >> $LOG 2>&1
check make -j2 install >> $LOG 2>&1
echo "[ctest]" >> $LOG 2>&1
ctest >> $LOG 2>&1

cat << EOF >> $PREFIX_ALPS/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_OPT/gcc-4.7.sh
. $PREFIX_ALPS/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/alpsvars.sh

### no-OpenMP version

VERSION="noomp-$ALPS_VERSION"
echo "[start alps-$VERSION]" >> $LOG 2>&1

rm -rf $BUILD_DIR/alps-build-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-$VERSION.$YMDT
echo "[cmake]" >> $LOG 2>&1
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$VERSION \
  -DCMAKE_C_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gcc" -DCMAKE_CXX_COMPILER="$PREFIX_OPT/gcc-4.7/bin/g++" -DCMAKE_Fortran_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gfortran" \
  -DMPIEXEC="/usr/lib64/lam/bin/mpirun" -DMPI_LIBRARY="/usr/lib64/lam/lib/libmpi.so;/usr/lib64/lam/lib/liblammpi++.so;/usr/lib64/lam/lib/liblam.so" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_VERSION -DALPS_BUILD_FORTRAN=ON \
  -DBLAS_LIBRARY=-lblas -DLAPACK_LIBRARY=-llapack \
  $HOME/build/alps-$ALPS_VERSION >> $LOG 2>&1

echo "[make install]" >> $LOG 2>&1
check make -j2 install >> $LOG 2>&1
echo "[ctest]" >> $LOG 2>&1
ctest >> $LOG 2>&1

cat << EOF >> $PREFIX_ALPS/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_OPT/gcc-4.7.sh
. $PREFIX_ALPS/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars-noomp.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/alpsvars-noomp.sh
