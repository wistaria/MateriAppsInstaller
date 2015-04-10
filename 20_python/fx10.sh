#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_PATCH_VERSION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
export LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH

$SUDO_TOOL /bin/true
sh $SCRIPT_DIR/setup.sh

cd $BUILD_DIR/Python-$PYTHON_VERSION
check ./configure --prefix=$PREFIX_FRONTEND --enable-shared
check make -j4
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH make install

cd $BUILD_DIR/nose-$NOSE_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/nose-$NOSE_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/distribute-$DISTRIBUTE_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/mock-$MOCK_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/pyparsing-$PYPARSING_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/pytz-$PYTZ_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/python-dateutil-$PYTHON_DATEUTIL_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/six-$SIX_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/numpy-$NUMPY_VERSION
cat << EOF > site.cfg
[DEFAULT]
library_dirs = $LAPACK_ROOT/Linux-x86_64/lib
EOF
check $PREFIX_FRONTEND/bin/python setup.py build --fcompiler=gnu95
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/scipy-$SCIPY_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build --fcompiler=gnu95
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cd $BUILD_DIR/matplotlib-$MATPLOTLIB_VERSION
check $PREFIX_FRONTEND/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX_FRONTEND/lib:$LD_LIBRARY_PATH $PREFIX_FRONTEND/bin/python setup.py install

cat << EOF > $BUILD_DIR/pythonvars.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
export PYTHON_ROOT=$PREFIX
export PYTHON_VERSION=$PYTHON_VERSION
export PYTHON_PATCH_VERSION=$PYTHON_PATCH_VERSION
export PATH=\$PYTHON_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PYTHONVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
