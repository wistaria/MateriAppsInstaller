#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

PYTHON3VARS_SH=$PREFIX_TOOL/python3/python3vars-$PYTHON3_VERSION-$PYTHON3_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/python3vars.sh
ln -s $PYTHON3VARS_SH $PREFIX_TOOL/env.d/python3vars.sh
