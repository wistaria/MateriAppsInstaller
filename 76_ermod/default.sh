#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

$SUDO_APPS true
. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/ermod-$ERMOD_VERSION-$ERMOD_MA_REVISION.log
PREFIX="$PREFIX_APPS/ermod/ermod-$ERMOD_VERSION-$ERMOD_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/ermod-$ERMOD_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX
cd vmdplugins
mkdir -p compile
check make dcdplugin.so gromacsplugin.so | tee -a $LOG
cd ..
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
echo "[install example]" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/share/ermod/example/gromacs
$SUDO_APPS cp -fp $BUILD_DIR/ermod-example-gromacs/* $PREFIX/share/ermod/example/gromacs/
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/ermodvars.sh
# ermod $(basename $0 .sh) $ERMOD_VERSION $ERMOD_MA_REVISION $(date +%Y%m%d-%H%M%S)
test -z "\$MA_ROOT_TOOL" && . $PREFIX_TOOL/env.sh
test -f \$MA_ROOT_APPS/gromacs/gromacsvars.sh && . \$MA_ROOT_APPS/gromacs/gromacsvars.sh
export ERMOD_ROOT=$PREFIX
export ERMOD_VERSION=$ERMOD_VERSION
export ERMOD_MA_REVISION=$ERMOD_MA_REVISION
export ERMOD_EXAMPLE_VERSION=$ERMOD_EXAMPLE_VERSION
export PATH=\$ERMOD_ROOT/bin:\$PATH
EOF
ERMODVARS_SH=$PREFIX_APPS/ermod/ermodvars-$ERMOD_VERSION-$ERMOD_MA_REVISION.sh
$SUDO_APPS rm -f $ERMODVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/ermodvars.sh $ERMODVARS_SH
rm -f $BUILD_DIR/ermodvars.sh
$SUDO_APPS cp -f $LOG $PREFIX_APPS/ermod/
