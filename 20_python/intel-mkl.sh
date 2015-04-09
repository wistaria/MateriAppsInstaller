#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_PATCH_VERSION
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

sh $SCRIPT_DIR/setup.sh

cd $BUILD_DIR/Python-$PYTHON_VERSION
check ./configure --prefix=$PREFIX --enable-shared
check make -j4
$SUDO_TOOL make install

cd $BUILD_DIR/nose-$NOSE_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/distribute-$DISTRIBUTE_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/mock-$MOCK_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/pyparsing-$PYPARSING_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/pytz-$PYTZ_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/python-dateutil-$PYTHON_DATEUTIL_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/six-$SIX_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/numpy-$NUMPY_VERSION
check patch -p1 < $SCRIPT_DIR/numpy-$NUMPY_VERSION.patch
cat << EOF > site.cfg
[mkl]
library_dirs = $(echo $MKLROOT | cut -d : -f 1)/lib/intel64
include_dirs = $(echo $MKLROOT | cut -d : -f 1)/include
mkl_libs = mkl_rt
lapack_libs =
EOF
check $PREFIX/bin/python setup.py config --compiler=intel build_clib --compiler=intel build_ext --compiler=intel
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/scipy-$SCIPY_VERSION
check $PREFIX/bin/python setup.py config --compiler=intel --fcompiler=intel build_clib --compiler=intel --fcompiler=intel build_ext --compiler=intel --fcompiler=intel
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cd $BUILD_DIR/matplotlib-$MATPLOTLIB_VERSION
check $PREFIX/bin/python setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python setup.py install

cat << EOF > $BUILD_DIR/pythonvars.sh
export PYTHON_ROOT=$PREFIX
export PYTHON_VERSION=$PYTHON_VERSION
export PYTHON_PATCH_VERSION=$PYTHON_PATCH_VERSION
export PATH=\$PYTHON_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$PYTHON_ROOT/lib:\$LD_LIBRARY_PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PYTHONVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
