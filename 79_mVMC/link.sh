#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

MVMCVARS_SH=$PREFIX_APPS/mVMC/mVMCvars-$MVMC_VERSION-$MVMC_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/mVMC/mVMCvars.sh
$SUDO_APPS ln -s $MVMCVARS_SH $PREFIX_APPS/mVMC/mVMCvars.sh

