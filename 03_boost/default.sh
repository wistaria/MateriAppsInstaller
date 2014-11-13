#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

$SUDO mkdir -p $PREFIX_TOOL
cd $PREFIX_TOOL
$SUDO rm -rf boost boost_$BOOST_VERSION
if [ -f $HOME/source/boost_$BOOST_VERSION.tar.bz2 ]; then
  $SUDO tar jxf $HOME/source/boost_$BOOST_VERSION.tar.bz2
else
  check wget -O - http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/boost_$BOOST_VERSION.tar.bz2/download | $SUDO tar jxf -
fi
$SUDO ln -s boost_$BOOST_VERSION $PREFIX_TOOL/boost
