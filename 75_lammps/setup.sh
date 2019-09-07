#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d lammps-$LAMMPS_VERSION ]; then :; else
  check mkdir -p lammps-$LAMMPS_VERSION
  check tar zxf $SOURCE_DIR/lammps-$LAMMPS_VERSION.tar.gz -C lammps-$LAMMPS_VERSION --strip-components=1
  cd lammps-$LAMMPS_VERSION
  if [ -f $SCRIPT_DIR/patches/series ]; then
    for p in $(cat $SCRIPT_DIR/patches/series); do
      if [ $p != debian.patch ]; then
        echo "applying $p"
        patch -p1 < $SCRIPT_DIR/patches/$p
      fi
    done
  fi
fi
