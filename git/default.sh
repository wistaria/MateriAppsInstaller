#!/bin/sh

SCRIPT_DIR=`dirname $0`
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

cd $BUILD_DIR
rm -rf git-$GIT_VERSION
if [ -f $HOME/source/git-$GIT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/git-$GIT_VERSION.tar.gz
else
  check wget -O - http://git-core.googlecode.com/files/git-$GIT_VERSION.tar.gz | tar zxf -
fi
cd git-$GIT_VERSION
check ./configure --prefix=$PREFIX_OPT --with-python=$PREFIX_OPT/bin/python2.7
LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH check make -j4
check $SUDO LD_LIBRARY_PATH=$PREFIX_OPT/lib:$LD_LIBRARY_PATH make install
