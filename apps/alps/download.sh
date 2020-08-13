#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/alps_$ALPS_VERSION_ORIG.orig.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/alps_$ALPS_VERSION_ORIG.orig.tar.gz $MALIVE_REPOSITORY/alps_$ALPS_VERSION_ORIG.orig.tar.gz
fi
