#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

TRIQSVARS_SH=$PREFIX_TOOL/alpscore/alpscorevars-$TRIQS_VERSION-$TRIQS_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/alpscorevars.sh
$SUDO_TOOL ln -s $TRIQSVARS_SH $PREFIX_TOOL/env.d/alpscorevars.sh
