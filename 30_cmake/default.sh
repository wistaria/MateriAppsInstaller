#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/cmake-$CMAKE_VERSION-$CMAKE_MA_REVISION.log
PREFIX=$PREFIX_TOOL/cmake/cmake-$CMAKE_VERSION-$CMAKE_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/cmake-$CMAKE_VERSION
echo "[make]" | tee -a $LOG
check ./bootstrap --prefix=$PREFIX | tee -a $LOG
check gmake -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL gmake install | tee -a $LOG

cat << EOF > $BUILD_DIR/cmakevars.sh
# cmake $(basename $0 .sh) $CMAKE_VERSION $CMAKE_MA_REVISION $(date +%Y%m%d-%H%M%S)
export CMAKE_ROOT=$PREFIX
export CMAKE_VERSION=$CMAKE_VERSION
export CMAKE_MA_REVISION=$CMAKE_MA_REVISION
export PATH=\$CMAKE_ROOT/bin:\$PATH
EOF
CMAKEVARS_SH=$PREFIX_TOOL/cmake/cmakevars-$CMAKE_VERSION-$CMAKE_MA_REVISION.sh
$SUDO_TOOL rm -f $CMAKEVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/cmakevars.sh $CMAKEVARS_SH
rm -f $BUILD_DIR/cmakevars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/cmake/
