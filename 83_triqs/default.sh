#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

#export TRIQS_CXX_STANDARD="c++1y"
#export TRIQS_CXX_STANDARD_FLAG="-std=c++1y"

. ./impl/default.sh
