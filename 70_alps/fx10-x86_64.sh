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

rm -rf $BUILD_DIR/alps-build-Linux-x86_64-$ALPS_VERSION && mkdir -p $BUILD_DIR/alps-build-Linux-x86_64-$ALPS_VERSION
cd $BUILD_DIR/alps-build-Linux-x86_64-$ALPS_VERSION
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/Linux-x86_64/alps-$ALPS_VERSION \
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

cat << EOF > $PREFIX_ALPS/Linux-x86_64/alpsvars-$ALPS_VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/Linux-x86_64/alps-$ALPS_VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/Linux-x86_64/alpsvars.sh
ln -s alpsvars-$ALPS_VERSION.sh $PREFIX_ALPS/Linux-x86_64/alpsvars.sh
ln -s Linux-x86_64/alpsvars.sh $PREFIX_ALPS/alpsvars-x86_64.sh
