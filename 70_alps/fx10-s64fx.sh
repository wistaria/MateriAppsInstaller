#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../03_boost/version.sh
start_info
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh
if [ -z "$MPI_HOME" ]; then
  MPI_HOME=$(dirname $(dirname $(which FCCpx)))
fi

cd $BUILD_DIR
if [ -d alps-$ALPS_VERSION ]; then :; else
  if [ -f $HOME/source/alps-$ALPS_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/alps-$ALPS_VERSION.tar.gz
  else
    check wget -O - http://exa.phys.s.u-tokyo.ac.jp/archive/source/alps-$ALPS_VERSION.tar.gz | tar zxf -
  fi
fi

rm -rf $BUILD_DIR/alps-build-Linux-s64fx-$ALPS_VERSION && mkdir -p $BUILD_DIR/alps-build-Linux-s64fx-$ALPS_VERSION
cd $BUILD_DIR/alps-build-Linux-s64fx-$ALPS_VERSION
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/Linux-s64fx/alps-$ALPS_VERSION \
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

cat << EOF > $PREFIX_ALPS/Linux-s64fx/alpsvars-$ALPS_VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/Linux-s64fx/alps-$ALPS_VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/Linux-s64fx/alpsvars.sh $PREFIX_ALPS/alpsvars-s64fx.sh
ln -s alpsvars-$ALPS_VERSION.sh $PREFIX_ALPS/Linux-s64fx/alpsvars.sh
ln -s Linux-s64fx/alpsvars.sh $PREFIX_ALPS/alpsvars-s64fx.sh

finish_info
