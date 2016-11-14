#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d lammps-$LAMMPS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/lammps-$LAMMPS_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/lammps_$LAMMPS_VERSION.tar.gz
  else
    check wget -O lammps-$LAMMPS_VERSION.tar.gz $WGET_OPTION https://github.com/lammps/lammps/archive/${LAMMPS_VERSION_REVISION}.tar.gz
    check tar zxf lammps-$LAMMPS_VERSION.tar.gz
    check mv lammps-$LAMMPS_VERSION_REVISION lammps-$LAMMPS_VERSION
  fi
fi
