#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
targetdir=${__NAME__}-${__VERSION__}
if [ -d $targetdir ]; then :; else
  check mkdir -p $targetdir
  tarfile=$SOURCE_DIR/qe-${__VERSION__}.tar.gz
  sc=`calc_strip_components $tarfile README.md`
  check tar zxf $tarfile -C $targetdir --strip-components=${sc}
  cd $targetdir
  if [ -f $SCRIPT_DIR/patches/series ]; then
    for p in $(cat $SCRIPT_DIR/patches/series); do
      if [ $p != debian.patch ]; then
        echo "applying $p"
        patch -p1 < $SCRIPT_DIR/patches/$p
      fi
    done
  fi
  if [ -d $SCRIPT_DIR/pseudo ]; then
    cp -fp $SCRIPT_DIR/pseudo/*.UPF pseudo
  fi
fi
