#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ESPRESSOVARS_SH=$PREFIX_APPS/espresso/espressovars-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION.sh
rm -f $PREFIX_APPS/espresso/espressovars.sh
ln -s $ESPRESSOVARS_SH $PREFIX_APPS/espresso/espressovars.sh
