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

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/xtapp_$XTAPP_VERSION
patch -p1 < $SCRIPT_DIR/xtapp-intel-mkl.patch
start_info | tee -a $LOG
echo "[make xtapp]" | tee -a $LOG
check make | tee -a $LOG

echo "[make xtapp-util]" | tee -a $LOG
cd $BUILD_DIR/xtapp_$XTAPP_VERSION/xtapp-util_$XTAPP_UTIL_VERSION
check make | tee -a $LOG

echo "[make install xtapp]" | tee -a $LOG
cd $BUILD_DIR/xtapp_$XTAPP_VERSION/src
make install PREFIX=$PREFIX | tee -a $LOG
cd $BUILD_DIR/xtapp_$XTAPP_VERSION
cp -rp sample debian/check debian/opendx $PREFIX

echo "[make install xtapp-util]" | tee -a $LOG
cd $BUILD_DIR/xtapp_$XTAPP_VERSION/xtapp-util_$XTAPP_UTIL_VERSION
make install PREFIX=$PREFIX | tee -a $LOG
cp -p conv-tapp3/ppot2x vbpef2gp-lsda/vbpef2gp-lsda $PREFIX/bin

echo "[make install xtapp-ps]" | tee -a $LOG
cd $BUILD_DIR/xtapp_$XTAPP_VERSION/xtapp-ps_$XTAPP_PS_VERSION
mkdir -p $PREFIX/pseudo-potential/PBE $PREFIX/pseudo-potential/PBE-nc $PREFIX/pseudo-potential/PBE-CAPZ
cp -rp xTAPP-PS-PBE/* $PREFIX/pseudo-potential/PBE
cp -rp xTAPP-PS-PBE-nc/* $PREFIX/pseudo-potential/PBE-nc
cp -rp xTAPP-PS-CAPZ/* $PREFIX/pseudo-potential/PBE-CAPZ
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/xtappvars.sh
. $PREFIX_TOOL/env.sh
export XTAPP_ROOT=$PREFIX
export PATH=\$XTAPP_ROOT/bin:\$PATH
EOF
XTAPPVARS_SH=$PREFIX_APPS/xtapp/xtappvars-$XTAPP_VERSION-$XTAPP_PATCH_VERSION.sh
rm -f $XTAPPVARS_SH
cp -f $BUILD_DIR/xtappvars.sh $XTAPPVARS_SH
cp -f $LOG $PREFIX_APPS/xtapp
