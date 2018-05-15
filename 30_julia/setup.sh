#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d julia-$JULIA_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz ]; then
    check tar zxf $SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz
  else
    check wget $WGET_OPTION -O julia-$JULIA_VERSION-full.tar.gz \
      https://github.com/JuliaLang/julia/releases/download/v$JULIA_VERSION/julia-$JULIA_VERSION-full.tar.gz
    check tar zxf julia-$JULIA_VERSION-full.tar.gz
  fi
  if [ -f $SCRIPT_DIR/julia_$JULIA_VERSION.patch ]; then
    cd $BUILD_DIR/julia-$JULIA_VERSION
    cat $SCRIPT_DIR/julia_$JULIA_VERSION.patch | patch -p1
  fi
fi

