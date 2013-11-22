#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh
. $PREFIX_OPT/gcc-4.7.sh

mkdir -p $PREFIX_ALPS/source $PREFIX_ALPS/script
check cp -p $0 $PREFIX_ALPS/script/compile-$ALPS_REVISION.sh
check cp -p $HOME/source/alps-$ALPS_REVISION.tar.gz $PREFIX_ALPS/source/

YMDT=`date +%Y%m%d%H%M%S`
LOG=$PREFIX_ALPS/script/compile-$ALPS_REVISION.$YMDT.log
rm -f $LOG
echo "LOG=$LOG"

echo "PREFIX=$PREFIX_ALPS" > $LOG
echo "ALPS_REVISION=$ALPS_REVISION" >> $LOG
echo "BOOST_REVISION=$BOOST_REVISION" >> $LOG
echo "SCRIPT=$PREFIX_ALPS/script/compile-$ALPS_REVISION.sh" >> $LOG
echo "LOG=$LOG" >> $LOG

(cd $BUILD_DIR && tar zxf $PREFIX_ALPS/source/alps-$ALPS_REVISION.tar.gz)

### OpenMP version

REVISION=$ALPS_REVISION
echo "[start alps-$REVISION]" >> $LOG 2>&1

rm -rf $BUILD_DIR/alps-build-$REVISION.$YMDT && mkdir -p $BUILD_DIR/alps-build-$REVISION.$YMDT
cd $BUILD_DIR/alps-build-$REVISION.$YMDT
echo "[cmake]" >> $LOG 2>&1
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$REVISION \
  -DCMAKE_C_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gcc" -DCMAKE_CXX_COMPILER="$PREFIX_OPT/gcc-4.7/bin/g++" -DCMAKE_Fortran_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gfortran" \
  -DMPIEXEC="/usr/lib64/lam/bin/mpirun" -DMPI_LIBRARY="/usr/lib64/lam/lib/libmpi.so;/usr/lib64/lam/lib/liblammpi++.so;/usr/lib64/lam/lib/liblam.so" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_REVISION -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON -DALPS_BUILD_FORTRAN=ON \
  -DBLAS_LIBRARY=-lblas -DLAPACK_LIBRARY=-llapack \
  $HOME/build/alps-$ALPS_REVISION >> $LOG 2>&1

echo "[make install]" >> $LOG 2>&1
check make -j2 install >> $LOG 2>&1
echo "[ctest]" >> $LOG 2>&1
ctest >> $LOG 2>&1

cat << EOF >> $PREFIX_ALPS/alpsvars-$REVISION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_OPT/gcc-4.7.sh
. $PREFIX_ALPS/alps-$REVISION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars.sh
ln -s alpsvars-$REVISION.sh $PREFIX_ALPS/alpsvars.sh

### no-OpenMP version

REVISION="noomp-$ALPS_REVISION"
echo "[start alps-$REVISION]" >> $LOG 2>&1

rm -rf $BUILD_DIR/alps-build-$REVISION.$YMDT && mkdir -p $BUILD_DIR/alps-build-$REVISION.$YMDT
cd $BUILD_DIR/alps-build-$REVISION.$YMDT
echo "[cmake]" >> $LOG 2>&1
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$REVISION \
  -DCMAKE_C_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gcc" -DCMAKE_CXX_COMPILER="$PREFIX_OPT/gcc-4.7/bin/g++" -DCMAKE_Fortran_COMPILER="$PREFIX_OPT/gcc-4.7/bin/gfortran" \
  -DMPIEXEC="/usr/lib64/lam/bin/mpirun" -DMPI_LIBRARY="/usr/lib64/lam/lib/libmpi.so;/usr/lib64/lam/lib/liblammpi++.so;/usr/lib64/lam/lib/liblam.so" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_REVISION -DALPS_BUILD_FORTRAN=ON \
  -DBLAS_LIBRARY=-lblas -DLAPACK_LIBRARY=-llapack \
  $HOME/build/alps-$ALPS_REVISION >> $LOG 2>&1

echo "[make install]" >> $LOG 2>&1
check make -j2 install >> $LOG 2>&1
echo "[ctest]" >> $LOG 2>&1
ctest >> $LOG 2>&1

cat << EOF >> $PREFIX_ALPS/alpsvars-$REVISION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_OPT/gcc-4.7.sh
. $PREFIX_ALPS/alps-$REVISION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars-noomp.sh
ln -s alpsvars-$REVISION.sh $PREFIX_ALPS/alpsvars-noomp.sh
