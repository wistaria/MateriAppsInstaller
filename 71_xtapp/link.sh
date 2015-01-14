#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

XTAPPVARS_SH=$PREFIX_APPS/xtapp/xtappvars-$XTAPP_VERSION-$XTAPP_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/xtapp/xtappvars.sh
$SUDO_APPS ln -s $XTAPPVARS_SH $PREFIX_APPS/xtapp/xtappvars.sh
