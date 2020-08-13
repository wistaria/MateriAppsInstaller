#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/komega-$KOMEGA_VERSION.tar.gz ]; then :; else
  check wget https://github.com/issp-center-dev/Komega/archive/v${KOMEGA_VERSION}.tar.gz -O $SOURCE_DIR/komega-${KOMEGA_VERSION}.tar.gz
fi
