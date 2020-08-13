#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $SOURCE_DIR
if [ -f boost_$BOOST_VERSION.tar.bz2 ]; then :; else
  check wget $WGET_OPTION -O boost_$BOOST_VERSION.tar.bz2 http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION_DOTTED/boost_$BOOST_VERSION.tar.bz2/download
fi
