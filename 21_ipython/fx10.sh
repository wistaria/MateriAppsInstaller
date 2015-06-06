#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
. $SCRIPT_DIR/../20_python/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/python/python-$PYTHON_VERSION-$PYTHON_PATCH_VERSION/Linux-x86_64

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

# markupsafe
cd $BUILD_DIR
$SUDO_TOOL rm -rf MarkupSafe-$MARKUPSAFE_VERSION
if [ -f $HOME/source/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
  check tar zxf MarkupSafe-$MARKUPSAFE_VERSION.tar.gz
fi
cd MarkupSafe-$MARKUPSAFE_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# jinja2
cd $BUILD_DIR
$SUDO_TOOL rm -rf Jinja2-$JINJA2_VERSION
if [ -f $HOME/source/Jinja2-$JINJA2_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Jinja2-$JINJA2_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/J/Jinja2/Jinja2-$JINJA2_VERSION.tar.gz
  check tar zxf Jinja2-$JINJA2_VERSION.tar.gz
fi
cd Jinja2-$JINJA2_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# docutils
cd $BUILD_DIR
$SUDO_TOOL rm -rf docutils-$DOCUTILS_VERSION
if [ -f $HOME/source/docutils-$DOCUTILS_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/docutils-$DOCUTILS_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/d/docutils/docutils-$DOCUTILS_VERSION.tar.gz
  check tar zxf docutils-$DOCUTILS_VERSION.tar.gz
fi
cd docutils-$DOCUTILS_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# Pygments
cd $BUILD_DIR
$SUDO_TOOL rm -rf Pygments-$PYGMENTS_VERSION
if [ -f $HOME/source/Pygments-$PYGMENTS_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Pygments-$PYGMENTS_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/P/Pygments/Pygments-$PYGMENTS_VERSION.tar.gz
  check tar zxf Pygments-$PYGMENTS_VERSION.tar.gz
fi
cd Pygments-$PYGMENTS_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# sphinx_rtd_theme
cd $BUILD_DIR
$SUDO_TOOL rm -rf sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION
if [ -f $HOME/source/sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz
  check tar zxf sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION.tar.gz
fi
cd sphinx_rtd_theme-$SPHINX_RTD_THEME_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# alabaster
cd $BUILD_DIR
$SUDO_TOOL rm -rf alabaster-$ALABASTER_VERSION
if [ -f $HOME/source/alabaster-$ALABASTER_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/alabaster-$ALABASTER_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/a/alabaster/alabaster-$ALABASTER_VERSION.tar.gz
  check tar zxf alabaster-$ALABASTER_VERSION.tar.gz
fi
cd alabaster-$ALABASTER_VERSION
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

# backports.ssl_match_hostname
cd $BUILD_DIR
$SUDO_TOOL rm -rf backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION
if [ -f $HOME/source/backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz
  check tar zxf backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION.tar.gz
fi
cd backports.ssl_match_hostname-$SSL_MATCH_HOSTNAME_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
$SUDO_TOOL env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py install

# certifi
cd $BUILD_DIR
$SUDO_TOOL rm -rf certifi-$CERTIFI_VERSION
if [ -f $HOME/source/certifi-$CERTIFI_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/certifi-$CERTIFI_VERSION.tar.gz
else
  check wget --no-check-certificate https://pypi.python.org/packages/source/c/certifi/certifi-$CERTIFI_VERSION.tar.gz
  check tar zxf certifi-$CERTIFI_VERSION.tar.gz
fi
cd certifi-$CERTIFI_VERSION
check env LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/python2.7 setup.py build
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
