#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

PREFIX=$PREFIX_TOOL/qt4/qt4-$QT4_VERSION-$QT4_PATCH_VERSION

sh $SCRIPT_DIR/setup.sh
cd $BUILD_DIR/qt-everywhere-opensource-src-$QT4_VERSION
check ./configure --prefix=$PREFIX --opensource --confirm-license=yes
check make -j4
make install

cat << EOF > $BUILD_DIR/qt4vars.sh
export QT4_ROOT=$PREFIX
export PATH=\$QT4_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$QT4_ROOT/lib:\$LD_LIBRARY_PATH
EOF
QT4VARS_SH=$PREFIX_TOOL/qt4/qt4vars-$QT4_VERSION-$QT4_PATCH_VERSION.sh
rm -f $QT4VARS_SH
cp -f $BUILD_DIR/qt4vars.sh $QT4VARS_SH
