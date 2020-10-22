#!/bin/sh

# SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
# . $SCRIPT_DIR/../../scripts/util.sh
# set_prefix
# . $PREFIX_TOOL/env.sh
# . $SCRIPT_DIR/version.sh
#
# wget $WGET_OPTION -O Python-$__VERSION__.tgz http://www.python.org/ftp/python/$__VERSION__/$__NAME__-$__VERSION__.tgz
# # wget $WGET_OPTION -O scipy-$SCIPY_VERSION.tar.gz http://pypi.python.org/packages/source/s/scipy/scipy-$SCIPY_VERSION.tar.gz
# wget $WGET_OPTION -O numpy-$NUMPY_VERSION.tar.gz http://pypi.python.org/packages/source/n/numpy/numpy-$NUMPY_VERSION.tar.gz
# pip --no-cache-dir download pip wheel matplotlib ipython sphinx pyzmq tornado mock toml

#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  check wget https://www.python.org/ftp/python/$__VERSION__/Python-$__VERSION__.tgz -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
fi
