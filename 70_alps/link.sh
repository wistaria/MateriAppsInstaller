#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$ALPS_VERSION-$ALPS_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/alps/alpsvars.sh
$SUDO_APPS ln -s alpsvars-$ALPS_VERSION.sh $PREFIX_APPS/alps/alpsvars.sh
