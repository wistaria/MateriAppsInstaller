#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

KOMEGAVARS_SH=$PREFIX_TOOL/komega/komegavars-$KOMEGA_VERSION-$KOMEGA_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/komegavars.sh
ln -s $KOMEGAVARS_SH $PREFIX_TOOL/env.d/komegavars.sh
