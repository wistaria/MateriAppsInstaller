#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSCORE_CTHYBVARS_SH=$PREFIX_APPS/alpscore-cthyb/alpscore-cthybvars-$ALPSCORE_CTHYB_VERSION-$ALPSCORE_CTHYB_MA_REVISION.sh
rm -f $PREFIX_APPS/alpscore-cthyb/alpscore-cthybvars.sh
ln -s $ALPSCORE_CTHYBVARS_SH $PREFIX_APPS/alpscore-cthyb/alpscore-cthybvars.sh
