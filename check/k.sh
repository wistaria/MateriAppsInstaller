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
sh $SCRIPT_DIR/../00_env/fx10.sh
sh $SCRIPT_DIR/../05_lapack/fx10.sh && sh $SCRIPT_DIR/../05_lapack/link.sh
sh $SCRIPT_DIR/../10_hdf5/fx10.sh && sh $SCRIPT_DIR/../10_hdf5/link.sh
sh $SCRIPT_DIR/../20_python/fx10.sh && sh $SCRIPT_DIR/../20_python/link.sh
sh $SCRIPT_DIR/../25_boost/fx10.sh && sh $SCRIPT_DIR/../25_boost/link-fx10.sh
sh $SCRIPT_DIR/../30_cmake/fx10.sh && sh $SCRIPT_DIR/../30_cmake/link.sh
sh $SCRIPT_DIR/../35_git/fx10.sh && sh $SCRIPT_DIR/../35_git/link.sh
sh $SCRIPT_DIR/../70_alps/fx10.sh && sh $SCRIPT_DIR/../70_alps/link.sh

###

source $PREFIX/env.sh
check_maversion
