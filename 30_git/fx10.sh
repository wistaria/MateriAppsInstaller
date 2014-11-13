#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX_FRONTEND="$PREFIX_TOOL/Linux-x86_64"

cd $BUILD_DIR
rm -rf git-$GIT_VERSION
if [ -f $HOME/source/git-$GIT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/git-$GIT_VERSION.tar.gz
else
  check wget -O - http://git-core.googlecode.com/files/git-$GIT_VERSION.tar.gz | tar zxf -
fi
cd git-$GIT_VERSION
check ./configure --prefix=$PREFIX_FRONTEND --with-python=$PREFIX_FRONTEND/bin/python2.7
check make -j4
$SUDO make install
