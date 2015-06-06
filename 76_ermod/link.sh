#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ERMODVARS_SH=$PREFIX_APPS/ermod/ermodvars-$ERMOD_VERSION-$ERMOD_MA_REVISION.sh
$SUDO_APPS rm -f $PREFIX_APPS/ermod/ermodvars.sh
$SUDO_APPS ln -s $ERMODVARS_SH $PREFIX_APPS/ermod/ermodvars.sh
