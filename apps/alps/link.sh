#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$ALPS_VERSION-$ALPS_MA_REVISION.sh
rm -f $PREFIX_APPS/alps/alpsvars.sh
ln -s $ALPSVARS_SH $PREFIX_APPS/alps/alpsvars.sh

BUILD_ARCH="Linux-x86_64 Linux-s64fx"
for arch in $BUILD_ARCH; do
  ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$arch-$ALPS_VERSION-$ALPS_MA_REVISION.sh
  if [ -f $ALPSVARS_SH ]; then
    rm -f $PREFIX_APPS/alps/alpsvars-$arch.sh
    ln -s $ALPSVARS_SH $PREFIX_APPS/alps/alpsvars-$arch.sh
  fi
done
