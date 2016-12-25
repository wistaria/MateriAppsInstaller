#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/gsl-$GSL_VERSION-$GSL_MA_REVISION.log
PREFIX=$PREFIX_TOOL/gsl/gsl-$GSL_VERSION-$GSL_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/gsl-$GSL_VERSION
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG

cat << EOF > $BUILD_DIR/gslvars.sh
# gsl $(basename $0 .sh) $GSL_VERSION $GSL_MA_REVISION $(date +%Y%m%d-%H%M%S)
export GSL_ROOT=$PREFIX
export GSL_VERSION=$GSL_VERSION
export GSL_MA_REVISION=$GSL_MA_REVISION
export PATH=\$GSL_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$GSL_ROOT/lib:\$LD_LIBRARY_PATH
EOF
GSLVARS_SH=$PREFIX_TOOL/gsl/gslvars-$GSL_VERSION-$GSL_MA_REVISION.sh
$SUDO_TOOL rm -f $GSLVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gslvars.sh $GSLVARS_SH
rm -f $BUILD_DIR/gslvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/gsl/
