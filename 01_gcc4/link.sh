#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

GCC4VARS_SH=$PREFIX_TOOL/gcc4/gcc4vars-$GCC4_VERSION-$GCC4_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/gcc4vars.sh
ln -s $GCC4VARS_SH $PREFIX_TOOL/env.d/gcc4vars.sh
