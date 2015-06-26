#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/boostvars.sh
$SUDO_TOOL ln -s $BOOSTVARS_SH $PREFIX_TOOL/env.d/boostvars.sh
