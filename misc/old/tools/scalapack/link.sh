#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

SCALAPACKVARS_SH=$PREFIX_TOOL/scalapack/scalapackvars-$SCALAPACK_VERSION-$SCALAPACK_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/scalapackvars.sh
ln -s $SCALAPACKVARS_SH $PREFIX_TOOL/env.d/scalapackvars.sh
