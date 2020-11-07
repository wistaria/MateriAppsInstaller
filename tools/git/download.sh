#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  check wget --no-check-certificate -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz https://www.kernel.org/pub/software/scm/git/${__NAME__}-${__VERSION__}.tar.gz
fi
