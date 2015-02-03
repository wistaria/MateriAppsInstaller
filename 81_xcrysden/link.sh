#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

XCRYSDENVARS_SH=$PREFIX_APPS/xcrysden/xcrysdenvars-$XCRYSDEN_VERSION-$XCRYSDEN_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/xcrysden/xcrysdenvars.sh
$SUDO_APPS ln -s $XCRYSDENVARS_SH $PREFIX_APPS/xcrysden/xcrysdenvars.sh
