#!/bin/sh

ROOT_FILE=CITATIONS.bib

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix
sh ${SCRIPT_DIR}/download.sh

NV=${__NAME__}-${__VERSION__}
cd $BUILD_DIR
if [ -d $NV ]; then :; else
  check mkdir -p $NV
  tarfile=$SOURCE_DIR/${NV}.tar.gz
  echo $PWD
  echo $tarfile
  sc=`calc_strip_components $tarfile $ROOT_FILE`
  check tar zxf $tarfile -C $NV --strip-components=$sc
  cd $NV
  if [ -f $SCRIPT_DIR/patch/${NV}.patch ]; then
    patch -p1 < $SCRIPT_DIR/patch/${NV}.patch
  fi
fi
