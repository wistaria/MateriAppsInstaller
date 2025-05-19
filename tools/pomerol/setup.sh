#!/bin/sh

ROOT_FILE=README.md

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix
sh ${SCRIPT_DIR}/download.sh

NV=${__NAME__}-${__VERSION__}
cd $BUILD_DIR
if [ -d $NV ]; then :; else
  # check mkdir -p $NV
  zipfile=$SOURCE_DIR/${NV}.zip
  check unzip $zipfile
  mv ${__NAME__}-${POMEROL_SHA} ${NV}
  cd $NV
  if [ -f $SCRIPT_DIR/patch/${NV}.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/${NV}.patch
  fi
fi
