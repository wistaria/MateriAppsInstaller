#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION-$PYTHON_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/pythonvars.sh
ln -s $PYTHONVARS_SH $PREFIX_TOOL/env.d/pythonvars.sh
