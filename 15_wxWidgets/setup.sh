#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d wxWidgets-$WXWIDGETS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/wxWidgets-$WXWIDGETS_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/wxWidgets-$WXWIDGETS_VERSION.tar.gz
  else
    check wget https://github.com/wxWidgets/wxWidgets/archive/v$WXWIDGETS_VERSION.tar.gz -O $SOURCE_DIR/wxWidgets-$WXWIDGETS_VERSION.tar.gz
    check tar zxf $SOURCE_DIR/wxWidgets-$WXWIDGETS_VERSION.tar.gz
  fi
fi
