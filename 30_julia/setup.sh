#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d julia-$JULIA_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz ]; then
    TARFILE=$SOURCE_DIR/julia-$JULIA_VERSION-full.tar.gz
  else
    check wget $WGET_OPTION -O julia-$JULIA_VERSION-full.tar.gz \
      https://github.com/JuliaLang/julia/releases/download/v$JULIA_VERSION/julia-$JULIA_VERSION-full.tar.gz
    TARFILE=julia-$JULIA_VERSION-full.tar.gz
  fi
  check tar zxf $TARFILE
  TOPDIR=$(tar --list -f $TARFILE | head -n1 | cut -d/ -f1 )
  if [ "$TOPDIR" != "julia-$JULIA_VERSION" ]; then
    mv $TOPDIR julia-$JULIA_VERSION
  fi
fi

