#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

TCLTKVARS_SH=$PREFIX_TOOL/tcltk/tcltkvars-$TCLTK_VERSION-$TCLTK_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/tcltkvars.sh
ln -s $TCLTKVARS_SH $PREFIX_TOOL/env.d/tcltkvars.sh
