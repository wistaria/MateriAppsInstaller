#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh
PREFIX_FRONTEND="$PREFIX_OPT/Linux-x86_64"

# TCL

cd $BUILD_DIR
rm -rf tcl$TCL_VERSION
if [ -f $HOME/source/tcl$TCL_VERSION-src.tar.gz ]; then
  check tar zxf $HOME/source/tcl$TCL_VERSION-src.tar.gz
else
  check wget -O - http://prdownloads.sourceforge.net/tcl/tcl$TCL_VERSION-src.tar.gz | tar zxf -
fi
cd tcl$TCL_VERSION/unix
check ./configure --prefix=$PREFIX_FRONTEND
check make -j4
$SUDO make install

# TK

cd $BUILD_DIR
rm -rf tk$TK_VERSION
if [ -f $HOME/source/tk$TK_VERSION-src.tar.gz ]; then
  check tar zxf $HOME/source/tk$TK_VERSION-src.tar.gz
else
  check wget -O - http://prdownloads.sourceforge.net/tcl/tk$TK_VERSION-src.tar.gz | tar zxf -
fi
cd tk$TK_VERSION/unix
check ./configure --prefix=$PREFIX_FRONTEND
check make -j4
$SUDO make install
