#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/tcltk-$TCLTK_VERSION-$TCLTK_MA_REVISION.log
PREFIX=$PREFIX_TOOL/tcltk/tcltk-$TCLTK_VERSION-$TCLTK_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

start_info | tee -a $LOG
cd $BUILD_DIR/tcl$TCLTK_VERSION/unix
echo "[TCL configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX_FRONTEND | tee -a $LOG
echo "[TCL make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[TCL make install]" | tee -a $LOG
$SUDO make install | tee -a $LOG

cd $BUILD_DIR/tk$TCLTK_VERSION/unix
echo "[TK configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX_FRONTEND | tee -a $LOG
echo "[TK make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[TK make install]" | tee -a $LOG
$SUDO make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/tcltkvars.sh
# tcltk $(basename $0 .sh) $TCLTK_VERSION $TCLTK_MA_REVISION $(date +%Y%m%d-%H%M%S)
OS=\$(uname -s)
ARCH=\$(uname -m)
export TCLTK_ROOT=$PREFIX
export PATH=\$TCLTK_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$TCLTK_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
TCLTKVARS_SH=$PREFIX_TOOL/tcltk/tcltkvars-$TCLTK_VERSION-$TCLTK_MA_REVISION.sh
$SUDO_TOOL rm -f $TCLTKVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/tcltkvars.sh $TCLTKVARS_SH
rm -f $BUILD_DIR/tcltkvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/tcltk/
