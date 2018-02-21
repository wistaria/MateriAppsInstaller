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
sh $SCRIPT_DIR/../11_eigen3/default.sh && sh $SCRIPT_DIR/../11_eigen3/link.sh
sh $SCRIPT_DIR/../25_boost/macos.sh && sh $SCRIPT_DIR/../25_boost/link.sh
sh $SCRIPT_DIR/../70_alps/macos.sh && sh $SCRIPT_DIR/../70_alps/link.sh
sh $SCRIPT_DIR/../78_hphi/default.sh && sh $SCRIPT_DIR/../78_hphi/link.sh

###

source $PREFIX/env.sh
check_maversion
