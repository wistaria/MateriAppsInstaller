#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_OPT/env.sh

check $SUDO mkdir -p $PREFIX_OPT
cd $PREFIX_OPT
$SUDO rm -rf boost_$BOOST_VERSION boost_$BOOST_FCC_VERSION
if [ -f $HOME/source/boost_$BOOST_VERSION.tar.bz2 ]; then
  check $SUDO tar jxf $HOME/source/boost_$BOOST_VERSION.tar.bz2
else
  check wget -O - http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/boost_$BOOST_VERSION.tar.bz2/download | $SUDO tar jxf -
fi
check $SUDO mv -f boost_$BOOST_VERSION boost_$BOOST_FCC_VERSION
cd $PREFIX_OPT/boost_$BOOST_FCC_VERSION
cat $SCRIPT_DIR/boost_$BOOST_FCC_VERSION.patch | check $SUDO patch -p1
