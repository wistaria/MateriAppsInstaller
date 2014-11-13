#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../03_boost/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

PREFIX_ALPS="$PREFIX_APPS/alps"

cd $BUILD_DIR
if [ -d alps-$ALPS_VERSION ]; then :; else
  if [ -f $HOME/source/alps-$ALPS_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/alps-$ALPS_VERSION.tar.gz
  else
    check wget -O - http://exa.phys.s.u-tokyo.ac.jp/archive/source/alps-$ALPS_VERSION.tar.gz | tar zxf -
  fi
  cd alps-$ALPS_VERSION
  patch -p1 < $SCRIPT_DIR/macosx-accelerate.patch
fi

rm -rf $BUILD_DIR/alps-build-$ALPS_VERSION
mkdir -p $BUILD_DIR/alps-build-$ALPS_VERSION
cd $BUILD_DIR/alps-build-$ALPS_VERSION
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$ALPS_VERSION \
  -DCMAKE_C_COMPILER="/opt/local/bin/gcc" -DCMAKE_CXX_COMPILER="/opt/local/bin/g++" -DCMAKE_Fortran_COMPILER="/opt/local/bin/gfortran" \
  -DPYTHON_INTERPRETER="/opt/local/bin/python2.7" \
  -DBoost_ROOT_DIR=$PREFIX_TOOL/boost_$BOOST_VERSION \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/alpsvars-$ALPS_VERSION.sh
. $PREFIX_TOOL/env.sh
. $PREFIX_ALPS/alps-$ALPS_VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars.sh
ln -s alpsvars-$ALPS_VERSION.sh $PREFIX_ALPS/alpsvars.sh
