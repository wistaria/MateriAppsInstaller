#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/wxWidgets-$WXWIDGETS_VERSION-$WXWIDGETS_MA_REVISION.log
PREFIX=$PREFIX_TOOL/wxWidgets/wxWidgets-$WXWIDGETS_VERSION-$WXWIDGETS_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/wxWidgets-$WXWIDGETS_VERSION
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX --with-gtk | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG

cat << EOF > $BUILD_DIR/wxWidgetsvars.sh
# hdf5 $(basename $0 .sh) $WXWIDGETS_VERSION $WXWIDGETS_MA_REVISION $(date +%Y%m%d-%H%M%S)
export WXWIDGETS_ROOT=$PREFIX
export WXWIDGETS_VERSION=$HDF5_VERSION
export WXWIDGETS_MA_REVISION=$HDF5_MA_REVISION
export PATH=\$WXWIDGETS_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$WXWIDGETS_ROOT/lib:\$LD_LIBRARY_PATH
EOF
WXWIDGETSVARS_SH=$PREFIX_TOOL/wxWidgets/wxWidgetsvars-$WXWIDGETS_VERSION-$WXWIDGETS_MA_REVISION.sh
rm -f $WXWIDGETSVARS_SH
cp -f $BUILD_DIR/wxWidgetsvars.sh $WXWIDGETSVARS_SH
rm -f $BUILD_DIR/wxWidgetsvars.sh
cp -f $LOG $PREFIX_TOOL/wxWidgets/
