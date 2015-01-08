#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/git/git-$GIT_VERSION-$GIT_PATCH_VERSION
PREFIX_FRONTEND=$PREFIX/Linux-x86_64

cd $BUILD_DIR
rm -rf git-$GIT_VERSION
if [ -f $HOME/source/git-$GIT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/git-$GIT_VERSION.tar.gz
else
  check wget -O - http://git-core.googlecode.com/files/git-$GIT_VERSION.tar.gz | tar zxf -
fi
cd git-$GIT_VERSION
check ./configure --prefix=$PREFIX_FRONTEND --with-python=$PYTHON_ROOT/Linux-x86_64/bin/python2.7
check make -j4
$SUDO_TOOL env LD_LIBRARY_PATH=$PYTHON_ROOT/Linux-x86_64/lib:$LD_LIBRARY_PATH make install

cat << EOF > $BUILD_DIR/gitvars.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
export GIT_ROOT=$PREFIX
export PATH=\$GIT_ROOT/\$OS-\$ARCH/bin:\$PATH
EOF
GITVARS_SH=$PREFIX_TOOL/git/gitvars-$GIT_VERSION-$GIT_PATCH_VERSION.sh
$SUDO_TOOL rm -f $GITVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gitvars.sh $GITVARS_SH
