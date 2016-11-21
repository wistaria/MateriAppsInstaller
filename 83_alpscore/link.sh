#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSCOREVARS_SH=$PREFIX_TOOL/alpscore/alpscorevars-$ALPSCORE_VERSION-$ALPSCORE_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/alpscorevars.sh
$SUDO_TOOL ln -s $ALPSCOREVARS_SH $PREFIX_TOOL/env.d/alpscorevars.sh
