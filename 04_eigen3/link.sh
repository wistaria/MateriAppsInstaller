#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

EIGEN3VARS_SH=$PREFIX_TOOL/eigen3/eigen3vars-$EIGEN3_VERSION-$EIGEN3_MA_REVISION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/eigen3vars.sh
$SUDO_TOOL ln -s $EIGEN3VARS_SH $PREFIX_TOOL/env.d/eigen3vars.sh
