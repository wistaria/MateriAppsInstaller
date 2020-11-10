#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

__VERSION_MAJOR_MINOR__=$(echo ${__VERSION__} | cut -d. -f1,2)

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.bz2 ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.bz2 https://support.hdfgroup.org/ftp/HDF5/releases/${__NAME__}-${__VERSION_MAJOR_MINOR__}/${__NAME__}-${__VERSION__}/src/${__NAME__}-${__VERSION__}.tar.bz2
fi
