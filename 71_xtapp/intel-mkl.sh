#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/xtapp-$XTAPP_VERSION-$XTAPP_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/xtapp/xtapp-$XTAPP_VERSION-$XTAPP_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/download.sh
rm -rf $LOG
cd $BUILD_DIR/xtapp/src
cp -fp Makefile-dist Makefile
cp -rp config90.h-dist config90.h
cp -rp config.h-dist config.h
patch -p2 < $SCRIPT_DIR/xtapp-intel-mkl.patch
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/xtappvars.sh
. $PREFIX_TOOL/env.sh
export XTAPP_ROOT=$PREFIX
export PATH=\$XTAPP_ROOT/bin:\$PATH
EOF
XTAPPVARS_SH=$PREFIX_APPS/xtapp/xtappvars-$XTAPP_VERSION-$XTAPP_PATCH_VERSION.sh
$SUDO_APPS rm -f $XTAPPVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/xtappvars.sh $XTAPPVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/xtapp
