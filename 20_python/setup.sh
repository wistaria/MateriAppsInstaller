#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
rm -rf Python-$PYTHON_VERSION
if [ -f $HOME/source/Python-$PYTHON_VERSION.tgz ]; then
  check tar zxf $HOME/source/Python-$PYTHON_VERSION.tgz
else
  check wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
  check tar zxf Python-$PYTHON_VERSION.tgz
fi
rm -rf nose-$NOSE_VERSION
if [ -f $HOME/source/nose-$NOSE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/nose-$NOSE_VERSION.tar.gz
else
  check wget http://pypi.python.org/packages/source/n/nose/nose-$NOSE_VERSION.tar.gz
  check tar zxf nose-$NOSE_VERSION.tar.gz
fi
$SUDO_TOOL rm -rf numpy-$NUMPY_VERSION
if [ -f $HOME/source/numpy-$NUMPY_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/numpy-$NUMPY_VERSION.tar.gz
else
  check wget -O  numpy-$NUMPY_VERSION.tar.gz http://sourceforge.net/projects/numpy/files/NumPy/$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz/download
  check tar zxf numpy-$NUMPY_VERSION.tar.gz
fi
rm -rf scipy-$SCIPY_VERSION
if [ -f $HOME/source/scipy-$SCIPY_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/scipy-$SCIPY_VERSION.tar.gz
else
  check wget -O scipy-$SCIPY_VERSION.tar.gz http://sourceforge.net/projects/scipy/files/scipy/$SCIPY_VERSION/scipy-$SCIPY_VERSION.tar.gz/download
  check tar zxf scipy-$SCIPY_VERSION.tar.gz
fi
rm -rf matplotlib-$MATPLOTLIB_VERSION
if [ -f $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/matplotlib-$MATPLOTLIB_VERSION.tar.gz
else
  check wget -O  matplotlib-$MATPLOTLIB_VERSION.tar.gz http://sourceforge.net/projects/matplotlib/files/matplotlib/matplotlib-$MATPLOTLIB_VERSION/matplotlib-$MATPLOTLIB_VERSION.tar.gz/download
  check tar zxf matplotlib-$MATPLOTLIB_VERSION.tar.gz
fi
