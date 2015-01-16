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
cd $BUILD_DIR/xtapp
patch -p1 < $SCRIPT_DIR/xtapp-macos.patch
start_info | tee -a $LOG
cd $BUILD_DIR/xtapp/src
echo "[make]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
cd $BUILD_DIR/xtapp/xtapp-util
echo "[make xtapp-util]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install xtapp-util]" | tee -a $LOG
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
$SUDO_APPS cp -fp conv-tapp3/ppot2x vbpef2gp-lsda/vbpef2gp-lsda $PREFIX/bin
cd $BUILD_DIR/xtapp/xtapp-ps_$XTAPP_PS_VERSION
echo "[make install xtapp-ps]" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/pseudo-potential/PBE $PREFIX/pseudo-potential/PBE-nc $PREFIX/pseudo-potential/PBE-CAPZ
$SUDO_APPS cp -frp xTAPP-PS-PBE/* $PREFIX/pseudo-potential/PBE
$SUDO_APPS cp -frp xTAPP-PS-PBE-nc/* $PREFIX/pseudo-potential/PBE-nc
$SUDO_APPS cp -frp xTAPP-PS-CAPZ/* $PREFIX/pseudo-potential/PBE-CAPZ
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
