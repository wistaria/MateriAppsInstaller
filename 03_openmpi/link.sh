#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

OPENMPIVARS_SH=$PREFIX_TOOL/openmpi/openmpivars-$OPENMPI_VERSION-$OPENMPI_MA_REVISION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/openmpivars.sh
$SUDO_TOOL ln -s $OPENMPIVARS_SH $PREFIX_TOOL/env.d/openmpivars.sh
