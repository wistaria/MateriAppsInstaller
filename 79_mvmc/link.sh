#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

MVMCVARS_SH=$PREFIX_APPS/mvmc/mvmcvars-$MVMC_VERSION-$MVMC_PATCH_VERSION.sh
rm -f $PREFIX_APPS/mvmc/mvmcvars.sh
ln -s $MVMCVARS_SH $PREFIX_APPS/mvmc/mvmcvars.sh
