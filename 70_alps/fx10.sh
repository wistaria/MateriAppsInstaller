#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../03_boost/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

mkdir -p $PREFIX_ALPS/source $PREFIX_ALPS/script
check cp -p $0 $PREFIX_ALPS/script/compile-$ALPS_VERSION.sh
check cp -p $HOME/source/alps-$ALPS_VERSION.tar.gz $PREFIX_ALPS/source/

YMDT=`date +%Y%m%d%H%M%S`

echo "PREFIX=$PREFIX_ALPS"
echo "ALPS_VERSION=$ALPS_VERSION"
echo "BOOST_VERSION=$BOOST_VERSION"
echo "SCRIPT=$PREFIX_ALPS/script/compile-$ALPS_VERSION.sh"

(cd $BUILD_DIR && tar zxf $PREFIX_ALPS/source/alps-$ALPS_VERSION.tar.gz)

### x86_64 OpenMP version

VERSION=$ALPS_VERSION
echo "[start x86_64 alps-$VERSION]"

rm -rf $BUILD_DIR/alps-build-Linux-x86_64-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-Linux-x86_64-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-Linux-x86_64-$VERSION.$YMDT
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/Linux-x86_64/alps-$VERSION \
  -DCMAKE_C_COMPILER="gcc" -DCMAKE_CXX_COMPILER="g++" -DCMAKE_Fortran_COMPILER="gfortran" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/Linux-x86_64/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/Linux-x86_64/lib \
  -DLAPACK_LIBRARIES="liblapack.so;/usr/lib64/libgfortran.so.1" \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_FCC_VERSION \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_BUILD_FORTRAN=ON \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/Linux-x86_64/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/Linux-x86_64/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/Linux-x86_64/alpsvars.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/Linux-x86_64/alpsvars.sh
ln -s Linux-x86_64/alpsvars.sh $PREFIX_ALPS/alpsvars-x86_64.sh

### x86_64 no-OpenMP version

VERSION="noomp-$ALPS_VERSION"
echo "[start x86_64 alps-$VERSION]"

rm -rf $BUILD_DIR/alps-build-Linux-x86_64-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-Linux-x86_64-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-Linux-x86_64-$VERSION.$YMDT
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/Linux-x86_64/alps-$VERSION \
  -DCMAKE_C_COMPILER="gcc" -DCMAKE_CXX_COMPILER="g++" -DCMAKE_Fortran_COMPILER="gfortran" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/Linux-x86_64/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/Linux-x86_64/lib \
  -DLAPACK_LIBRARIES="liblapack.so;/usr/lib64/libgfortran.so.1" \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_FCC_VERSION \
  -DALPS_BUILD_FORTRAN=ON \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/Linux-x86_64/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/Linux-x86_64/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/Linux-x86_64/alpsvars-noomp.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/Linux-x86_64/alpsvars-noomp.sh
ln -s Linux-x86_64/alpsvars-noomp.sh $PREFIX_ALPS/alpsvars-noomp.sh

### s64fx OpenMP version

VERSION=$ALPS_VERSION
echo "[start s64fx alps-$VERSION]"

rm -rf $BUILD_DIR/alps-build-Linux-s64fx-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-Linux-s64fx-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-Linux-s64fx-$VERSION.$YMDT
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/Linux-s64fx/alps-$VERSION \
  -DCMAKE_CXX_COMPILER=mpiFCCpx -DCMAKE_CXX_FLAGS_RELEASE="-w -Xg -Kfast,ocl,ilfunc -KPIC -Nnoline --alternative_tokens -Dmain=MAIN__" -DCMAKE_C_COMPILER=mpifccpx -DCMAKE_C_FLAGS_RELEASE="-w -Xg -Kfast,ocl,ilfunc -KPIC -Nnoline -Dmain=MAIN__" -DCMAKE_Fortran_COMPILER=mpifrtpx -DCMAKE_Fortran_FLAGS_RELEASE="-w -Kfast -KPIC" \
  -DCMAKE_EXE_LINKER_FLAGS="-SSL2" -DCMAKE_SHARED_LINKER_FLAGS="-SSL2" \
  -DCMAKE_COMMAND=$CMAKE_PATH -DCMAKE_CTEST_COMMAND=$CTEST_PATH \
  -DMPI_COMPILE_FLAGS="-lmpi" -DMPI_INCLUDE_PATH=$MPI_HOME/include/mpi/fujitsu -DMPI_LIBRARY=$MPI_HOME/lib64/libmpi.so \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/Linux-s64fx/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/Linux-s64fx/lib \
  -DLAPACK_FOUND=TRUE \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_FCC_VERSION \
  -DOpenMP_CXX_FLAGS=-Kopenmp -DOpenMP_C_FLAGS=-Kopenmp \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_INCLUDE_TUTORIALS=OFF -DALPS_BUILD_APPLICATIONS=OFF -DALPS_BUILD_EXAMPLES=OFF -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=OFF \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install

cat << EOF > $PREFIX_ALPS/Linux-s64fx/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/Linux-s64fx/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/Linux-s64fx/alpsvars.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/Linux-s64fx/alpsvars.sh
ln -s Linux-s64fx/alpsvars.sh $PREFIX_ALPS/alpsvars-s64fx.sh

### s64fx no-OpenMP version

VERSION="noomp-$ALPS_VERSION"
echo "[start s64fx alps-$VERSION]"

rm -rf $BUILD_DIR/alps-build-Linux-s64fx-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-Linux-s64fx-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-Linux-s64fx-$VERSION.$YMDT
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/Linux-s64fx/alps-$VERSION \
  -DCMAKE_CXX_COMPILER=mpiFCCpx -DCMAKE_CXX_FLAGS_RELEASE="-w -Xg -Kfast,ocl,ilfunc -KPIC -Nnoline --alternative_tokens -Dmain=MAIN__" -DCMAKE_C_COMPILER=mpifccpx -DCMAKE_C_FLAGS_RELEASE="-w -Xg -Kfast,ocl,ilfunc -KPIC -Nnoline -Dmain=MAIN__" -DCMAKE_Fortran_COMPILER=mpifrtpx -DCMAKE_Fortran_FLAGS_RELEASE="-w -Kfast -KPIC" \
  -DCMAKE_EXE_LINKER_FLAGS="-SSL2" -DCMAKE_SHARED_LINKER_FLAGS="-SSL2" \
  -DCMAKE_COMMAND=$CMAKE_PATH -DCMAKE_CTEST_COMMAND=$CTEST_PATH \
  -DMPI_COMPILE_FLAGS="-lmpi" -DMPI_INCLUDE_PATH=$MPI_HOME/include/mpi/fujitsu -DMPI_LIBRARY=$MPI_HOME/lib64/libmpi.so \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/Linux-s64fx/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/Linux-s64fx/lib \
  -DLAPACK_FOUND=TRUE \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_FCC_VERSION \
  -DALPS_INCLUDE_TUTORIALS=OFF -DALPS_BUILD_APPLICATIONS=OFF -DALPS_BUILD_EXAMPLES=OFF -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=OFF \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/Linux-s64fx/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/Linux-s64fx/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/Linux-s64fx/alpsvars-noomp.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/Linux-s64fx/alpsvars-noomp.sh
ln -s Linux-s64fx/alpsvars-noomp.sh $PREFIX_ALPS/alpsvars-noomp.sh
