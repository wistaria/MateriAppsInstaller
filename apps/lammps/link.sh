#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ESPRESSOVARS_SH=$PREFIX_APPS/espresso/espressovars-${__VERSION__}-${__MA_REVISION__}.sh
rm -f $PREFIX_APPS/$__NAME__/${__NAME__}vars.sh
ln -s $ESPRESSOVARS_SH $PREFIX_APPS/$__NAME__/${__NAME__}vars.sh
