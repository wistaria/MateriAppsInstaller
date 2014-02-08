#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../03_boost/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

cd $BUILD_DIR
if [ -d alps-$ALPS_VERSION ]; then :; else
  if [ -f $HOME/source/alps-$ALPS_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/alps-$ALPS_VERSION.tar.gz
  else
    check wget -O - http://exa.phys.s.u-tokyo.ac.jp/archive/source/alps-$ALPS_VERSION.tar.gz | tar zxf -
  fi
fi

MPI_HOME=$(dirname $(dirname $(which fcc)))
export PATH=$PREFIX_OPT/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX_OPT/lib:$MPI_HOME/lib64:$LD_LIBRARY_PATH

VERSION="fcc-$ALPS_VERSION"

rm -rf $BUILD_DIR/alps-build-$VERSION && mkdir -p $BUILD_DIR/alps-build-$VERSION
cd $BUILD_DIR/alps-build-$VERSION
echo "[cmake]"
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$VERSION \
  -DCMAKE_CXX_COMPILER=mpiFCC -DCMAKE_CXX_FLAGS_RELEASE="-w -Xg -Kfast,ocl -KPIC -Kcmodel=small -Nnoline --alternative_tokens -Dmain=MAIN__" -DCMAKE_C_COMPILER=mpifcc -DCMAKE_C_FLAGS_RELEASE="-w -Xg -Kfast,ocl,ilfunc -KPIC -Kcmodel=small -Nnoline -Dmain=MAIN__" -DCMAKE_Fortran_COMPILER=mpifrt -DCMAKE_Fortran_FLAGS_RELEASE="-w -Kfast -KPIC -Kcmodel=small" \
  -DCMAKE_EXE_LINKER_FLAGS="-SSL2" -DCMAKE_SHARED_LINKER_FLAGS="-SSL2" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DLAPACK_FOUND=TRUE \
  -DMPI_COMPILE_FLAGS="-lmpi" -DMPI_INCLUDE_PATH=$MPI_HOME/include/mpi/fujitsu -DMPI_LIBRARY=$MPI_HOME/lib64/libmpi.so \
  -DHdf5_INCLUDE_DIRS=$HOME/opt/include -DHdf5_LIBRARY_DIRS=$HOME/opt/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_FCC_VERSION -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON -DALPS_BUILD_PYTHON=OFF -DALPS_BUILD_APPLICATIONS=OFF -DALPS_BUILD_EXAMPLES=OFF -DALPS_BUILD_FORTRAN=ON \
  -DOpenMP_CXX_FLAGS=-Kopenmp -DOpenMP_C_FLAGS=-Kopenmp \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/alpsvars-$VERSION.sh
MPI_HOME=$(dirname $(dirname $(which fcc)))
export LD_LIBRARY_PATH=\$MPI_HOME/lib64:\$LD_LIBRARY_PATH
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars-fcc.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/alpsvars-fcc.sh
