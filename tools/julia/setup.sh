#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  git clone git://github.com/JuliaLang/julia.git julia-${__VERSION__}
  (cd ${__NAME__}-${__VERSION__} && git checkout v${__VERSION__})
  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    cd ${__NAME__}-${__VERSION__}
    cat $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch | patch -p1
  fi
fi
