#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)/../
. $SCRIPT_DIR/scripts/util.sh

echo "[Tools]"
cat $SCRIPT_DIR/tools/*/version.sh | grep '_VERSION=' | sort

echo "[Applications]"
cat $SCRIPT_DIR/apps/*/version.sh | grep '_VERSION=' | sort
