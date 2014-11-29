#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

CMAKEVARS_SH=$PREFIX_TOOL/cmake/cmakevars-$CMAKE_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/cmakevars.sh
$SUDO_TOOL ln -s $CMAKEVARS_SH $PREFIX_TOOL/env.d/cmakevars.sh
