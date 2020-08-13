#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $MA_ROOT/env.sh

HPHIVARS_SH=$MA_ROOT/hphi/hphivars-$HPHI_VERSION-$HPHI_MA_REVISION.sh
rm -f $MA_ROOT/hphi/hphivars.sh
ln -s $HPHIVARS_SH $MA_ROOT/hphi/hphivars.sh
