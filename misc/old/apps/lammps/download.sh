#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/lammps-$LAMMPS_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/lammps-$LAMMPS_VERSION.tar.gz https://github.com/lammps/lammps/archive/${LAMMPS_DOWNLOAD_VERSION}.tar.gz
fi
