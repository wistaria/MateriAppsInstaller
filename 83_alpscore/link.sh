#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSCOREVARS_SH=$PREFIX_APPS/alpscore/alpscorevars-$ALPSCORE_VERSION-$ALPSCORE_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/alpscore/alpscorevars.sh
$SUDO_APPS ln -s $ALPSCOREVARS_SH $PREFIX_APPS/alpscore/alpscorevars.sh

BUILD_ARCH="Linux-x86_64 Linux-s64fx"
for arch in $BUILD_ARCH; do
  ALPSCOREVARS_SH=$PREFIX_APPS/alpscore/alpscorevars-$arch-$ALPSCORE_VERSION-$ALPSCORE_PATCH_VERSION.sh
  if [ -f $ALPSCOREVARS_SH ]; then
    $SUDO_APPS rm -f $PREFIX_APPS/alpscore/alpscorevars-$arch.sh
    $SUDO_APPS ln -s $ALPSCOREVARS_SH $PREFIX_APPS/alpscore/alpscorevars-$arch.sh
  fi
done
