#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

TRIQSVARS_SH=$PREFIX_APPS/triqs/triqsvars-$TRIQS_VERSION-$TRIQS_MA_REVISION.sh
rm -f $PREFIX_APPS/triqs/triqsvars.sh
ln -s $TRIQSVARS_SH $PREFIX_APPS/triqs/triqsvars.sh
