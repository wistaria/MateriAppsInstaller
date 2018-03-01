#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d lammps-$LAMMPS_VERSION ]; then :; else
  if [ -f lammps-$LAMMPS_VERSION.tar.gz ]; then :; else
    if [ -f $SOURCE_DIR/lammps-$LAMMPS_VERSION.tar.gz ]; then
      cp $SOURCE_DIR/lammps_$LAMMPS_VERSION.tar.gz .
    else
      check wget -O lammps-$LAMMPS_VERSION.tar.gz $WGET_OPTION https://github.com/lammps/lammps/archive/stable_${LAMMPS_DOWNLOAD_VERSION}.tar.gz
    fi
  fi
  check mkdir -p lammps-$LAMMPS_VERSION
  check tar zxf lammps-$LAMMPS_VERSION.tar.gz -C lammps-$LAMMPS_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/lammps-$LAMMPS_VERSION.patch ]; then
    cd lammps-$LAMMPS_VERSION
    patch -p1 < $SCRIPT_DIR/lammps-$LAMMPS_VERSION.patch
  fi
fi
