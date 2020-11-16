#!/bin/sh
set -e

mode=${1:-default}
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
CONFIG_DIR=$SCRIPT_DIR/config/$mode
if [ ! -d $CONFIG_DIR ]; then
  echo "Error: unknown mode: $mode"
  exit 127
fi

. $SCRIPT_DIR/../scripts/util.sh
set_prefix

mkdir -p $MA_ROOT/env.d $MA_ROOT/lib
sh $CONFIG_DIR/setup.sh
