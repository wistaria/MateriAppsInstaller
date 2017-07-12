#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

GCCVARS_SH=$PREFIX_TOOL/gcc/gccvars-$GCC_VERSION-$GCC_MA_REVISION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/gccvars.sh
$SUDO_TOOL ln -s $GCCVARS_SH $PREFIX_TOOL/env.d/gccvars.sh
