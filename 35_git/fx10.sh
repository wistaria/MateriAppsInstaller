#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/git-$GIT_VERSION-$GIT_MA_REVISION.log
PREFIX=$PREFIX_TOOL/git/git-$GIT_VERSION-$GIT_MA_REVISION
PREFIX_FRONTEND=$PREFIX/Linux-x86_64

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

start_info | tee -a $LOG

cd $BUILD_DIR/git-$GIT_VERSION
echo "[configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX_FRONTEND --with-python=$PYTHON_ROOT/Linux-x86_64/bin/python2.7 | tee -a $LOG
echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
$SUDO_TOOL env LD_LIBRARY_PATH=$PYTHON_ROOT/Linux-x86_64/lib:$LD_LIBRARY_PATH make install | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/gitvars.sh
# git $(basename $0 .sh) $GIT_VERSION $GIT_MA_REVISION $(date +%Y%m%d-%H%M%S)
OS=\$(uname -s)
ARCH=\$(uname -m)
export GIT_ROOT=$PREFIX
export PATH=\$GIT_ROOT/\$OS-\$ARCH/bin:\$PATH
EOF
GITVARS_SH=$PREFIX_TOOL/git/gitvars-$GIT_VERSION-$GIT_MA_REVISION.sh
$SUDO_TOOL rm -f $GITVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gitvars.sh $GITVARS_SH
rm -f $BUILD_DIR/gitvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/git/
