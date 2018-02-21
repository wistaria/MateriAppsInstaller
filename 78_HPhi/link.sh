#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhivars-$HPHI_VERSION-$HPHI_MA_REVISION.sh
rm -f $PREFIX_APPS/HPhi/HPhivars.sh
ln -s $HPHIVARS_SH $PREFIX_APPS/HPhi/HPhivars.sh
