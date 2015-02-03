#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

LOG=$BUILD_DIR/ignition-$IGNITION_VERSION-$IGNITION_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/ignition/ignition-$IGNITION_VERSION-$IGNITION_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/ignition-$IGNITION_VERSION
start_info | tee -a $LOG
echo "[configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX
echo "[make]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/ignitionvars.sh
. $PREFIX_TOOL/env.sh
export IGNITION_ROOT=$PREFIX
export PATH=\$IGNITION_ROOT/bin:\$PATH
EOF
IGNITIONVARS_SH=$PREFIX_APPS/ignition/ignitionvars-$IGNITION_VERSION-$IGNITION_PATCH_VERSION.sh
$SUDO_APPS rm -f $IGNITIONVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/ignitionvars.sh $IGNITIONVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/ignition
