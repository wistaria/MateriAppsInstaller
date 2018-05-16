#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

JULIAVARS_SH=$PREFIX_TOOL/julia/juliavars-$JULIA_VERSION-$JULIA_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/juliavars.sh
ln -s $JULIAVARS_SH $PREFIX_TOOL/env.d/juliavars.sh
