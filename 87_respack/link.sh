#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

RESPACKVARS_SH=$PREFIX_APPS/respack/respackvars-$RESPACK_VERSION-$RESPACK_MA_REVISION.sh
rm -f $PREFIX_APPS/respack/respackvars.sh
ln -s $RESPACKVARS_SH $PREFIX_APPS/respack/respackvars.sh
