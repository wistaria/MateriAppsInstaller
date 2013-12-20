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

### OpenMP version

VERSION=$ALPS_VERSION
echo "[start alps-$VERSION]"

rm -rf $BUILD_DIR/alps-build-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-$VERSION.$YMDT
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$VERSION \
  -DCMAKE_C_COMPILER="icc" -DCMAKE_CXX_COMPILER="icpc" -DCMAKE_Fortran_COMPILER="ifort" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_VERSION \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_BUILD_FORTRAN=ON \
  $HOME/build/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/alpsvars.sh

### no-OpenMP version

VERSION="noomp-$ALPS_VERSION"
echo "[start alps-$VERSION]"

rm -rf $BUILD_DIR/alps-build-$VERSION.$YMDT && mkdir -p $BUILD_DIR/alps-build-$VERSION.$YMDT
cd $BUILD_DIR/alps-build-$VERSION.$YMDT
echo "[cmake]"
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$VERSION \
  -DCMAKE_C_COMPILER="icc" -DCMAKE_CXX_COMPILER="icpc" -DCMAKE_Fortran_COMPILER="ifort" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DHdf5_INCLUDE_DIRS=$PREFIX_OPT/include -DHdf5_LIBRARY_DIRS=$PREFIX_OPT/lib \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_VERSION \
  -DALPS_BUILD_FORTRAN=ON \
  $HOME/build/alps-$ALPS_VERSION

echo "[make install]"
check make -j2 install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/alpsvars-$VERSION.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars-noomp.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/alpsvars-noomp.sh
