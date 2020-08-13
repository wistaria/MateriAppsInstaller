#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d tcl$TCLTK_VERSION ]; then :; else
  if [ -f $HOME/source/tcl$TCLTK_VERSION-src.tar.gz ]; then
    check tar zxf $HOME/source/tcl$TCLTK_VERSION-src.tar.gz
  else
    check wget http://prdownloads.sourceforge.net/tcl/tcl$TCLTK_VERSION-src.tar.gz
    check tar zxf tcl$TCLTK_VERSION-src.tar.gz
  fi
fi
if [ -d tk$TCLTK_VERSION ]; then :; else
  if [ -f $HOME/source/tk$TCLTK_VERSION-src.tar.gz ]; then
    check tar zxf $HOME/source/tk$TCLTK_VERSION-src.tar.gz
  else
    check wget http://prdownloads.sourceforge.net/tcl/tk$TCLTK_VERSION-src.tar.gz
    check tar zxf tk$TCLTK_VERSION-src.tar.gz
  fi
fi
