#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../03_boost/version.sh
start_info
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

. /home/etc/intel.sh
export PATH=$PREFIX_OPT/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH

VERSION="icc-$ALPS_VERSION"

rm -rf $BUILD_DIR/alps-build-$VERSION && mkdir -p $BUILD_DIR/alps-build-$VERSION
cd $BUILD_DIR/alps-build-$VERSION
echo "[cmake]"
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$VERSION \
  -DCMAKE_C_COMPILER="icc" -DCMAKE_CXX_COMPILER="icpc" -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG -DMPICH_IGNORE_CXX_SEEK -DMPICH_SKIP_MPICXX" -DCMAKE_Fortran_COMPILER="ifort" \
  -DPYTHON_INTERPRETER=python2.7 \
  -DBoost_ROOT_DIR=$PREFIX_OPT/boost_$BOOST_FCC_VERSION -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON -DALPS_BUILD_APPLICATIONS=OFF -DALPS_BUILD_FORTRAN=ON \
  $BUILD_DIR/alps-$ALPS_VERSION

echo "[make install]"
check make install
echo "[ctest]"
ctest

cat << EOF > $PREFIX_ALPS/alpsvars-$VERSION.sh
. /home/etc/intel.sh
. $PREFIX_OPT/env.sh
. $PREFIX_ALPS/alps-$VERSION/bin/alpsvars.sh
EOF
rm -f $PREFIX_ALPS/alpsvars-icc.sh
ln -s alpsvars-$VERSION.sh $PREFIX_ALPS/alpsvars-icc.sh

finish_info
