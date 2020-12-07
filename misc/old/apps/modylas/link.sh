#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

MODYLASVARS_SH=$PREFIX_APPS/modylas/modylasvars-$MODYLAS_VERSION-$MODYLAS_PATCH_VERSION.sh
rm -f $PREFIX_APPS/modylas/modylasvars.sh
ln -s $MODYLASVARS_SH $PREFIX_APPS/modylas/modylasvars.sh
