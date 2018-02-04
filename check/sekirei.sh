#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
MAINSTALLER_CONFIG=$HOME/.mainstaller-check
PREFIX=$HOME/materiapps-check
BUILD_DIR=$PREFIX/build

rm -rf $MAINSTALLER_CONFIG $PREFIX $BUILD_DIR
mkdir -p $PREFIX $BUILD_DIR

cat << EOF > $MAINSTALLER_CONFIG
PREFIX=$PREFIX
BUILD_DIR=$BUILD_DIR
EOF

###

export MAINSTALLER_CONFIG
sh $SCRIPT_DIR/../00_env/default.sh
sh $SCRIPT_DIR/../06_fftw/intel.sh && sh $SCRIPT_DIR/../06_fftw/link.sh
sh $SCRIPT_DIR/../10_hdf5/default.sh && sh $SCRIPT_DIR/../10_hdf5/link.sh
sh $SCRIPT_DIR/../20_python/intel-mkl.sh && sh $SCRIPT_DIR/../20_python/link.sh
sh $SCRIPT_DIR/../25_boost/intel.sh && sh $SCRIPT_DIR/../25_boost/link.sh
sh $SCRIPT_DIR/../30_cmake/default.sh && sh $SCRIPT_DIR/../30_cmake/link.sh
sh $SCRIPT_DIR/../35_git/default.sh && sh $SCRIPT_DIR/../35_git/link.sh
sh $SCRIPT_DIR/../70_alps/intel-mkl.sh && sh $SCRIPT_DIR/../70_alps/link.sh

###

source $PREFIX/env.sh
check_maversion
