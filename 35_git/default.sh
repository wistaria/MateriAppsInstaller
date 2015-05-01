#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/git/git-$GIT_VERSION-$GIT_PATCH_VERSION

cd $BUILD_DIR
rm -rf git-$GIT_VERSION
if [ -f $HOME/source/git-$GIT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/git-$GIT_VERSION.tar.gz
else
  check wget -O - http://www.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz | tar zxf -
fi
cd git-$GIT_VERSION
check ./configure --prefix=$PREFIX --with-python=$PYTHON_ROOT/bin/python2.7
check make -j4
$SUDO_TOOL env LD_LIBRARY_PATH=$PYTHON_ROOT/lib:$LD_LIBRARY_PATH make install

cat << EOF > $BUILD_DIR/gitvars.sh
export GIT_ROOT=$PREFIX
export PATH=\$GIT_ROOT/bin:\$PATH
EOF
GITVARS_SH=$PREFIX_TOOL/git/gitvars-$GIT_VERSION-$GIT_PATCH_VERSION.sh
$SUDO_TOOL rm -f $GITVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/gitvars.sh $GITVARS_SH
