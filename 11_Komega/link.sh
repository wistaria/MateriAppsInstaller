#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

KOMEGAVARS_SH=$PREFIX_TOOL/Komega/Komegavars-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION.sh
rm -f $PREFIX_TOOL/Komega/Komegavars.sh
ln -s $KOMEGAVARS_SH $PREFIX_TOOL/Komega/Komegavars.sh

