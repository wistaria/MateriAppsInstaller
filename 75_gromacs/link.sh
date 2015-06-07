#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

GROMACSVARS_SH=$PREFIX_APPS/gromacs/gromacsvars-$GROMACS_VERSION-$GROMACS_MA_REVISION.sh
$SUDO_APPS rm -f $PREFIX_APPS/gromacs/gromacsvars.sh
$SUDO_APPS ln -s $GROMACSVARS_SH $PREFIX_APPS/gromacs/gromacsvars.sh
