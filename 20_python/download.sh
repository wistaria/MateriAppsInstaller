#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

wget $WGET_OPTION http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
wget $WGET_OPTION https://bootstrap.pypa.io/get-pip.py
wget $WGET_OPTION http://pypi.python.org/packages/source/s/scipy/scipy-$SCIPY_VERSION.tar.gz
wget $WGET_OPTION http://pypi.python.org/packages/source/n/numpy/numpy-$NUMPY_VERSION.tar.gz
pip --no-cache-dir download pip matplotlib ipython mock
