#!/bin/sh

appname=$1

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ -f $SCRIPT_DIR/${appname}.sh ]; then
  sh $SCRIPT_DIR/${appname}.sh
else
  sh $SCRIPT_DIR/test_single.sh $appname
fi
