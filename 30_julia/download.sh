#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz ]; then :; else
  check wget $WGET_OPTION -O $SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz \
    https://github.com/JuliaLang/julia/releases/download/v$JULIA_VERSION/julia-$JULIA_VERSION-full.tar.gz
fi
