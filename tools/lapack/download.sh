#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz http://www.netlib.org/${__NAME__}/${__NAME__}-${__VERSION__}.tgz
fi
if [ -f $SOURCE_DIR/${__NAME_BLAS__}-${__VERSION_BLAS__}.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME_BLAS__}-${__VERSION_BLAS__}.tar.gz https://github.com/xianyi/OpenBLAS/releases/download/v${__VERSION_BLAS__}/OpenBLAS-${__VERSION_BLAS__}.tar.gz
fi
