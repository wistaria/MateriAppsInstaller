#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/Komega-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION.log

PREFIX="$PREFIX_TOOL/Komega/Komega-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/Komega-$KOMEGA_VERSION
start_info | tee -a $LOG
echo "[configure]" | tee -a $LOG
./configure --prefix=$PREFIX --with-mpi
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/Komegavars.sh
. $PREFIX_TOOL/env.sh
export KOMEGA_ROOT=$PREFIX
export PATH=\$KOMEGA_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$KOMEGA_ROOT/lib:\$LD_LIBRARY_PATH
EOF
KOMEGAVARS_SH=$PREFIX_TOOL/Komega/Komegavars-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION.sh
$SUDO_TOOLS rm -f $KOMEGAVARS_SH
$SUDO_TOOLS cp -f $BUILD_DIR/Komegavars.sh $KOMEGAVARS_SH
$SUDO_TOOLS cp -f $LOG $PREFIX_TOOL/Komega
