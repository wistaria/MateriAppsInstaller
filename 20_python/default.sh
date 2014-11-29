#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION

cd $BUILD_DIR
rm -rf Python-$PYTHON_VERSION
if [ -f $HOME/source/Python-$PYTHON_VERSION.tar.bz2 ]; then
  check tar jxf $HOME/source/Python-$PYTHON_VERSION.tar.bz2
else
  check wget -O - http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.bz2 | tar jxf -
fi
cd Python-$PYTHON_VERSION
check ./configure --prefix=$PREFIX --enable-shared
check make -j4
$SUDO_TOOL make install

cd $BUILD_DIR
rm -rf nose-$NOSE_VERSION
if [ -f $HOME/source/nose-$NOSE_VERSION.tar.gz ]; then
  tar zxf $HOME/source/nose-$NOSE_VERSION.tar.gz
else
  wget http://pypi.python.org/packages/source/n/nose/nose-$NOSE_VERSION.tar.gz | tar zxf -
fi
cd nose-$NOSE_VERSION
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH check $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

cd $BUILD_DIR
$SUDO_TOOL rm -rf numpy-$NUMPY_VERSION
if [ -f$HOME/source/numpy-$NUMPY_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/numpy-$NUMPY_VERSION.tar.gz
else
  check wget -O - http://sourceforge.net/projects/numpy/files/NumPy/$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz/download numpy-$NUMPY_VERSION.tar.gz | tar zxf -
fi
cd numpy-$NUMPY_VERSION
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH check $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

cd $BUILD_DIR
rm -rf scipy-$SCIPY_VERSION
if [ -f $HOME/source/scipy-$SCIPY_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/scipy-$SCIPY_VERSION.tar.gz
else
  check wget -O - http://sourceforge.net/projects/scipy/files/scipy/$SCIPY_VERSION/scipy-$SCIPY_VERSION.tar.gz/download scipy-$SCIPY_VERSION.tar.gz | tar zxf -
fi
cd scipy-$SCIPY_VERSION
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH check $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

cd $BUILD_DIR
rm -rf matplotlib-$MATPLOTLIB_VERSION
if [ -f $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz
else
  check wget -O - http://sourceforge.net/projects/matplotlib/files/matplotlib/matplotlib-$MATPLOTLIB_VERSION/matplotlib-$MATPLOTLIB_VERSION.tar.gz/download matplotlib-$MATPLOTLIB_VERSION.tar.gz | tar zxf -
fi
cd matplotlib-$MATPLOTLIB_VERSION
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH check $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

cat << EOF > $BUILD_DIR/pythonvars.sh
export PATH=$PREFIX/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:\$LD_LIBRARY_PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION.sh
$SUDO_TOOL rm -f $PYTHONVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
