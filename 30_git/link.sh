#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

GITVARS_SH=$PREFIX_TOOL/git/gitvars-$GIT_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/gitvars.sh
$SUDO_TOOL ln -s $GITVARS_SH $PREFIX_TOOL/env.d/gitvars.sh
