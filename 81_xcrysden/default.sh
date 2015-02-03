#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/xcrysden-$XCRYSDEN_VERSION-$XCRYSDEN_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/xcrysden/xcrysden-$XCRYSDEN_VERSION-$XCRYSDEN_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/xcrysden-$XCRYSDEN_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check ln -s system/Make.sys-shared Make.sys
check make | tee -a $LOG
echo "[make install xcrysden]" | tee -a $LOG
$SUDO_APPS make install prefix=$PREFIX | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/xcrysdenvars.sh
. $PREFIX_TOOL/env.sh
export XCRYSDEN_ROOT=$PREFIX
export PATH=\$XCRYSDEN_ROOT/bin:\$PATH
EOF
XCRYSDENVARS_SH=$PREFIX_APPS/xcrysden/xcrysdenvars-$XCRYSDEN_VERSION-$XCRYSDEN_PATCH_VERSION.sh
$SUDO_APPS rm -f $XCRYSDENVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/xcrysdenvars.sh $XCRYSDENVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/xcrysden
