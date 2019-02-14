#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/util.sh

TOOL=$(ls $SCRIPT_DIR | grep '^[0-6][0-9]_*')
APPS=$(ls $SCRIPT_DIR | grep '^[7-9][0-9]_*')

echo "[Tools]"
cat $SCRIPT_DIR/[0-6][0-9]_*/version.sh | grep '_VERSION=' | sort

echo "[Applications]"
cat $SCRIPT_DIR/[7-9][0-9]_*/version.sh | grep '_VERSION=' | sort
