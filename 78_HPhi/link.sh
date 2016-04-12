#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhivars-$HPHI_VERSION-$HPHI_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/HPhi/HPhivars.sh
$SUDO_APPS ln -s $HPHIVARS_SH $PREFIX_APPS/HPhi/HPhivars.sh

