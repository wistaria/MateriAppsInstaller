#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/openmx-$OPENMX_VERSION-$OPENMX_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/openmx/openmx-$OPENMX_VERSION-$OPENMX_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/openmx-$OPENMX_VERSION
patch -p1 < $SCRIPT_DIR/openmx-macos.patch
cd source
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/bin
$SUDO_APPS make install DESTDIR=$PREFIX/bin | tee -a $LOG
cd $BUILD_DIR/openmx-$OPENMX_VERSION
$SUDO_APPS cp -rp openmx*.pdf DFT_DATA13 work $PREFIX
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/openmxvars.sh
. $PREFIX_TOOL/env.sh
export OPENMX_ROOT=$PREFIX
export PATH=\$OPENMX_ROOT/bin:\$PATH
EOF
OPENMXVARS_SH=$PREFIX_APPS/openmx/openmxvars-$OPENMX_VERSION-$OPENMX_PATCH_VERSION.sh
$SUDO_APPS rm -f $OPENMXVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/openmxvars.sh $OPENMXVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/openmx
