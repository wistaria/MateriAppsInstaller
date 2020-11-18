#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION_MM__}.tar.gz ]; then :; else
  check wget http://t-ozaki.issp.u-tokyo.ac.jp/openmx${__VERSION_MM__}.tar.gz -O ${SOURCE_DIR}/${__NAME__}-${__VERSION_MM__}.tar.gz
fi

if [ "$__VERSION_PATCH__" != "0" ]; then
  if [ -f $SOURCE_DIR/${__NAME__}-patch-${__VERSION__}.tar.gz ]; then :; else
    check wget http://www.openmx-square.org/bugfixed/${OPENMX_RELEASE_DATE}/patch${__VERSION__}.tar.gz -O ${SOURCE_DIR}/${__NAME__}-patch-${__VERSION__}.tar.gz
  fi
fi
