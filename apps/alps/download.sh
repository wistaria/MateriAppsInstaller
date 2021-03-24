#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  rm -rf $SOURCE_DIR/${__NAME__}_${__VERSION__}
  svn export --non-interactive --trust-server-cert -r ${__VERSION_REVISION__} ${__URL__} ${__NAME__}-${__VERSION__}
  tar zcvf $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ${__NAME__}-${__VERSION__}
  rm -rf ${__NAME__}-${__VERSION__}
fi
