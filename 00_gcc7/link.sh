#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

GCC7VARS_SH=$PREFIX_TOOL/gcc7/gcc7vars-$GCC7_VERSION-$GCC7_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/gcc7vars.sh
ln -s $GCC7VARS_SH $PREFIX_TOOL/env.d/gcc7vars.sh
