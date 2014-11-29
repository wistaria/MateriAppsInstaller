#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$PYTHON_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/pythonvars.sh
$SUDO_TOOL ln -s $PYTHONVARS_SH $PREFIX_TOOL/env.d/pythonvars.sh
