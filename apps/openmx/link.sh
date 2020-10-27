#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $MA_ROOT/env.sh

VARS_SH=$MA_ROOT/${__NAME__}/${__NAME__}vars-$__VERSION__-$__MA_REVISION__.sh
rm -f $MA_ROOT/${__NAME__}/${__NAME__}vars.sh
ln -s $VARS_SH $MA_ROOT/${__NAME__}/${__NAME__}vars.sh
