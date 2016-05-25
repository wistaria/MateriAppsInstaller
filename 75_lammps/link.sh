#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

LAMMPSVARS_SH=$PREFIX_APPS/lammps/lammpsvars-$LAMMPS_VERSION_NUMERIC-$LAMMPS_MA_REVISION.sh
$SUDO_APPS rm -f $PREFIX_APPS/lammps/lammpsvars.sh
$SUDO_APPS ln -s $LAMMPSVARS_SH $PREFIX_APPS/lammps/lammpsvars.sh
