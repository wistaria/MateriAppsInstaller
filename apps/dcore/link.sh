#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

DCOREVARS_SH=$PREFIX_APPS/dcore/dcorevars-$DCORE_VERSION-$DCORE_MA_REVISION.sh
rm -f $PREFIX_APPS/dcore/dcorevars.sh
ln -s $DCOREVARS_SH $PREFIX_APPS/dcore/dcorevars.sh

