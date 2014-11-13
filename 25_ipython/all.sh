#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

# setuptools
cd $BUILD_DIR
rm -rf setuptools-$SETUPTOOLS_VERSION
if [ -f $HOME/source/setuptools-$SETUPTOOLS_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/setuptools-$SETUPTOOLS_VERSION.tar.gz
else  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/s/setuptools/setuptools-$SETUPTOOLS_VERSION.tar.gz | tar zxf -
fi
cd setuptools-$SETUPTOOLS_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# pexpect
cd $BUILD_DIR
rm -rf pexpect-$PEXPECT_VERSION
if [ -f $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/p/pexpect/pexpect-$PEXPECT_VERSION.tar.gz | tar zxf -
fi
cd pexpect-$PEXPECT_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# markupsafe
cd $BUILD_DIR
rm -rf MarkupSafe-$MARKUPSAFE_VERSION
if [ -f $HOME/source/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz | tar zxf -
fi
cd MarkupSafe-$MARKUPSAFE_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# jinja2
cd $BUILD_DIR
rm -rf Jinja2-$JINJA2_VERSION
if [ -f $HOME/source/Jinja2-$JINJA2_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Jinja2-$JINJA2_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/J/Jinja2/Jinja2-$JINJA2_VERSION.tar.gz | tar zxf -
fi
cd Jinja2-$JINJA2_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# docutils
cd $BUILD_DIR
rm -rf docutils-$DOCUTILS_VERSION
if [ -f $HOME/source/docutils-$DOCUTILS_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/docutils-$DOCUTILS_VERSION.tar.gz
else  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/d/docutils/docutils-$DOCUTILS_VERSION.tar.gz | tar zxf -
fi
cd docutils-$DOCUTILS_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# Pygments
cd $BUILD_DIR
rm -rf Pygments-$PYGMENTS_VERSION
if [ -f $HOME/source/Pygments-$PYGMENTS_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Pygments-$PYGMENTS_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/J/Pygments/Pygments-$PYGMENTS_VERSION.tar.gz | tar zxf -
fi
cd Pygments-$PYGMENTS_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# sphinx
cd $BUILD_DIR
rm -rf Sphinx-$SPHINX_VERSION
if [ -f $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/S/Sphinx/Sphinx-$SPHINX_VERSION.tar.gz | tar zxf -
fi
cd Sphinx-$SPHINX_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# zeromq
cd $BUILD_DIR
rm -rf zeromq-$ZEROMQ_VERSION
if [ -f $HOME/source/zeromq-$ZEROMQ_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/zeromq-$ZEROMQ_VERSION.tar.gz
else
  check wget --no-check-certificate -O - http://download.zeromq.org/zeromq-$ZEROMQ_VERSION.tar.gz | tar zxf -
fi
cd zeromq-$ZEROMQ_VERSION
./configure --prefix=$PREFIX_TOOL
check make -j4
$SUDO make install

# pyzmq
cd $BUILD_DIR
rm -rf pyzmq-$PYZMQ_VERSION
if [ -f $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/p/pyzmq/pyzmq-$PYZMQ_VERSION.tar.gz | tar zxf -
fi
cd pyzmq-$PYZMQ_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build --zmq=$PREFIX_TOOL
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# backports.ssl_match_hostname
cd $BUILD_DIR
rm -rf backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION
if [ -f $HOME/source/backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/t/backports.ssl_match_hostname/backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz | tar zxf -
fi
cd backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# tornado
cd $BUILD_DIR
rm -rf tornado-$TORNADO_VERSION
if [ -f $HOME/source/tornado-$TORNADO_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/tornado-$TORNADO_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/t/tornado/tornado-$TORNADO_VERSION.tar.gz | tar zxf -
fi
cd tornado-$TORNADO_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install

# ipython
cd $BUILD_DIR
rm -rf ipython-$IPYTHON_VERSION
if [ -f $HOME/source/ipython-$IPYTHON_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/ipython-$IPYTHON_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/i/ipython/ipython-$IPYTHON_VERSION.tar.gz | tar zxf -
fi
cd ipython-$IPYTHON_VERSION
check env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py build
$SUDO env LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$LD_LIBRARY_PATH $PREFIX_TOOL/bin/python2.7 setup.py install
