#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LAPACKVARS_SH=$PREFIX_TOOL/lapack/lapackvars-$LAPACK_VERSION-$LAPACK_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/lapackvars.sh
ln -s $LAPACKVARS_SH $PREFIX_TOOL/env.d/lapackvars.sh
