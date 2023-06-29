#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  wget https://exa.phys.s.u-tokyo.ac.jp/archive/MateriApps/src/${__NAME__}_$(echo ${__VERSION__} | sed 's/-/~/').orig.tar.gz -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
fi
