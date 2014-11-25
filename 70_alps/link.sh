#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

PREFIX_ALPS="$PREFIX_APPS/alps"

$SUDO_APPS rm -f $PREFIX_ALPS/alpsvars.sh
$SUDO_APPS ln -s alpsvars-$ALPS_VERSION.sh $PREFIX_ALPS/alpsvars.sh
