#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

WGETVARS_SH=$PREFIX_TOOL/wget/wgetvars-$WGET_VERSION-$WGET_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/wgetvars.sh
ln -s $WGETVARS_SH $PREFIX_TOOL/env.d/wgetvars.sh
