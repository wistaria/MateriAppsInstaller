#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.bz2 ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.bz2 https://www.open-mpi.org/software/ompi/v$(echo ${__VERSION__} | cut -d . -f 1,2)/downloads/${__NAME__}-${__VERSION__}.tar.bz2
fi
