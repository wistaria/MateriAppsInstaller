#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

TAPIOCAVARS_SH=$PREFIX_APPS/tapioca/tapiocavars-$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/tapioca/tapiocavars.sh
$SUDO_APPS ln -s $TAPIOCAVARS_SH $PREFIX_APPS/tapioca/tapiocavars.sh
