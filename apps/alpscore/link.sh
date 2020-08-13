#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSCOREVARS_SH=$PREFIX_TOOL/alpscore/alpscorevars-$ALPSCORE_VERSION-$ALPSCORE_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/alpscorevars.sh
ln -s $ALPSCOREVARS_SH $PREFIX_TOOL/env.d/alpscorevars.sh
