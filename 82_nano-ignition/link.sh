#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

IGNITIONVARS_SH=$PREFIX_APPS/ignition/ignitionvars-$IGNITION_VERSION-$IGNITION_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/ignition/ignitionvars.sh
$SUDO_APPS ln -s $IGNITIONVARS_SH $PREFIX_APPS/ignition/tapiocavars.sh
