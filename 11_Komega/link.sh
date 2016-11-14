#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

KOMEGAVARS_SH=$PREFIX_APPS/Komega/Komegavars-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/Komega/Komegavars.sh
$SUDO_APPS ln -s $KOMEGAVARS_SH $PREFIX_APPS/Komega/Komegavars.sh

