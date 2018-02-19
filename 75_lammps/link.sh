#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

LAMMPSVARS_SH=$PREFIX_APPS/lammps/lammpsvars-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.sh
rm -f $PREFIX_APPS/lammps/lammpsvars.sh
ln -s $LAMMPSVARS_SH $PREFIX_APPS/lammps/lammpsvars.sh
