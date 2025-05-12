#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

NV=${__NAME__}-${__VERSION__}
cd $BUILD_DIR
if [ -d $NV ]; then :; else
  git clone https://github.com/ALPSCore/CT-HYB-SEGMENT $NV
  cd $NV
  git checkout ${__VERSION__}
  if [ -f $SCRIPT_DIR/patch/${NV}.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/${NV}.patch
  fi
fi
