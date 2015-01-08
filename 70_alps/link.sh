#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$ALPS_VERSION-$ALPS_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/alps/alpsvars.sh
$SUDO_APPS ln -s $ALPSVARS_SH $PREFIX_APPS/alps/alpsvars.sh

BUILD_ARCH="Linux-x86_64 Linux-s64fx"
for arch in $BUILD_ARCH; do
  ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$arch-$ALPS_VERSION-$ALPS_PATCH_VERSION.sh
  if [ -f $ALPSVARS_SH ]; then
    $SUDO_APPS rm -f $PREFIX_APPS/alps/alpsvars-$arch.sh
    $SUDO_APPS ln -s $ALPSVARS_SH $PREFIX_APPS/alps/alpsvars-$arch.sh
  fi
done
