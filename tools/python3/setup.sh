#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh ${SCRIPT_DIR}/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  check mkdir -p ${__NAME__}-$__VERSION__
  tarfile=$SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
  sc=`calc_strip_components $tarfile README.rst`
  check tar zxf $tarfile -C ${__NAME__}-${__VERSION__} --strip-components=$sc
  cd ${__NAME__}-$__VERSION__
  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch
  fi
fi

# cd $BUILD_DIR
# if [ -d Python-$__VERSION__ ]; then :; else
#   if [ -f $SOURCE_DIR/python/Python-$__VERSION__.tgz ]; then
#     check tar zxf $SOURCE_DIR/python/Python-$__VERSION__.tgz
#   else
#     check wget $WGET_OPTION http://www.python.org/ftp/python/$__VERSION__/Python-$__VERSION__.tgz
#     check tar zxf Python-$__VERSION__.tgz
#   fi
# fi
#
# cd $BUILD_DIR/Python-$__VERSION__
# if [ -d numpy-$NUMPY_VERSION ]; then :; else
#   if [ -f $SOURCE_DIR/python/numpy-$NUMPY_VERSION.tar.gz ]; then
#     check tar zxf $SOURCE_DIR/python/numpy-$NUMPY_VERSION.tar.gz
#   else
#     check wget $WGET_OPTION https://github.com/numpy/numpy/releases/download/v$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz -O numpy-$NUMPY_VERSION.tar.gz
#     check tar zxf numpy-$NUMPY_VERSION.tar.gz
#   fi
# fi
#
# cd $BUILD_DIR/Python-$__VERSION__
# if [ -d scipy-$SCIPY_VERSION ]; then :; else
#   if [ -f $SOURCE_DIR/python/scipy-$SCIPY_VERSION.tar.gz ]; then
#     check tar zxf $SOURCE_DIR/python/scipy-$SCIPY_VERSION.tar.gz
#   else
#     check wget $WGET_OPTION https://github.com/scipy/scipy/releases/download/v$SCIPY_VERSION/scipy-$SCIPY_VERSION.tar.gz -O scipy-$SCIPY_VERSION.tar.gz 
#     check tar zxf scipy-$SCIPY_VERSION.tar.gz
#   fi
# fi
