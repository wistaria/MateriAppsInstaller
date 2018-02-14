#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

GCC49VARS_SH=$PREFIX_TOOL/gcc49/gcc49vars-$GCC49_VERSION-$GCC49_MA_REVISION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/gcc49vars.sh
$SUDO_TOOL ln -s $GCC49VARS_SH $PREFIX_TOOL/env.d/gcc49vars.sh
