#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

URL=https://github.com/lammps/lammps/archive/refs/tags/${LAMMPS_DOWNLOAD_VERSION}.tar.gz
ARCHIVE=${SOURCE_DIR}/${__NAME__}-${__VERSION__}.tar.gz

if [ -f $ARCHIVE ]; then :; else
  check wget $URL -O $ARCHIVE
fi
