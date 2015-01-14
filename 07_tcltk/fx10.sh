#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/tcltk/tcltk-$TCL_VERSION-$TCLTK_PATCH_VERSION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"

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

cat << EOF > $BUILD_DIR/tcltkvars.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
export TCLTK_ROOT=$PREFIX
export PATH=\$TCLTK_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$TCKTK_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
TCKTKVARS_SH=$PREFIX_TOOL/tcltk/tcltkvars-$TCK_VERSION-$TCKTK_PATCH_VERSION.sh
$SUDO_TOOL rm -f $TCLCKVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/tcltkvars.sh $TCKTKVARS_SH
