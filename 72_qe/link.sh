#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

QEVARS_SH=$PREFIX_APPS/qe/qevars-$QE_VERSION-$QE_MA_REVISION.sh
rm -f $PREFIX_APPS/qe/qevars.sh
ln -s $QEVARS_SH $PREFIX_APPS/qe/qevars.sh
