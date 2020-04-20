#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

TENESVARS_SH=$PREFIX_APPS/tenes/tenesvars-$TENES_VERSION-$TENES_MA_REVISION.sh
rm -f $PREFIX_APPS/tenes/tenesvars.sh
ln -s $TENESVARS_SH $PREFIX_APPS/tenes/tenesvars.sh

BUILD_ARCH="Linux-x86_64 Linux-s64fx"
for arch in $BUILD_ARCH; do
  TENESVARS_SH=$PREFIX_APPS/tenes/tenesvars-$arch-$TENES_VERSION-$TENES_MA_REVISION.sh
  if [ -f $TENESVARS_SH ]; then
    rm -f $PREFIX_APPS/tenes/tenesvars-$arch.sh
    ln -s $TENESVARS_SH $PREFIX_APPS/tenes/tenesvars-$arch.sh
  fi
done
