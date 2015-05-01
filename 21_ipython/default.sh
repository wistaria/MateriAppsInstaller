#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../20_python/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_PATCH_VERSION

# pexpect
cd $BUILD_DIR
$SUDO_TOOL rm -rf pexpect-$PEXPECT_VERSION
if [ -f $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/p/pexpect/pexpect-$PEXPECT_VERSION.tar.gz
  check tar zxf pexpect-$PEXPECT_VERSION.tar.gz
fi
cd pexpect-$PEXPECT_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# sphinx
cd $BUILD_DIR
$SUDO_TOOL rm -rf Sphinx-$SPHINX_VERSION
if [ -f $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/S/Sphinx/Sphinx-$SPHINX_VERSION.tar.gz
  check tar zxf Sphinx-$SPHINX_VERSION.tar.gz
fi
cd Sphinx-$SPHINX_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# pyzmq
cd $BUILD_DIR
$SUDO_TOOL rm -rf pyzmq-$PYZMQ_VERSION
if [ -f $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/p/pyzmq/pyzmq-$PYZMQ_VERSION.tar.gz
  check tar zxf pyzmq-$PYZMQ_VERSION.tar.gz
fi
cd pyzmq-$PYZMQ_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build --zmq=bundled
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# tornado
cd $BUILD_DIR
$SUDO_TOOL rm -rf tornado-$TORNADO_VERSION
if [ -f $HOME/source/tornado-$TORNADO_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/tornado-$TORNADO_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/t/tornado/tornado-$TORNADO_VERSION.tar.gz
  check tar zxf tornado-$TORNADO_VERSION.tar.gz
fi
cd tornado-$TORNADO_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# ipython
cd $BUILD_DIR
$SUDO_TOOL rm -rf ipython-$IPYTHON_VERSION
if [ -f $HOME/source/ipython-$IPYTHON_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/ipython-$IPYTHON_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/i/ipython/ipython-$IPYTHON_VERSION.tar.gz
  check tar zxf ipython-$IPYTHON_VERSION.tar.gz
fi
cd ipython-$IPYTHON_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install
