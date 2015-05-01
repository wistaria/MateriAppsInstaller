#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

LAPACKVARS_SH=$PREFIX_TOOL/lapack/lapackvars-$LAPACK_VERSION-$LAPACK_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/lapackvars.sh
$SUDO_TOOL ln -s $LAPACKVARS_SH $PREFIX_TOOL/env.d/lapackvars.sh
