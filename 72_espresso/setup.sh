#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d espresso-$ESPRESSO_VERSION ]; then :; else
  check mkdir -p espresso-$ESPRESSO_VERSION
  check tar zxf $SOURCE_DIR/qe-$ESPRESSO_VERSION.tar.gz -C espresso-$ESPRESSO_VERSION --strip-components=1
  cd espresso-$ESPRESSO_VERSION
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
