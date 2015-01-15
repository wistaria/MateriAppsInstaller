#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_download_url

cd $BUILD_DIR
if [ -d xtapp ]; then :; else
  if [ -f $HOME/source/xtapp_$XTAPP_VERSION.orig.tar.gz ]; then
    check tar zxf $HOME/source/xtapp_$XTAPP_VERSION.orig.tar.gz
  else
    check wget -O - "$MALIVE_REPOSITORY/main/x/xtapp/xtapp_$XTAPP_VERSION.orig.tar.gz" | tar zxf -
  fi
  cd xtapp
  if [ -f $HOME/source/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz ]; then
    tar zxf $HOME/source/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz
  else
    check wget -O - "$MALIVE_REPOSITORY/main/x/xtapp/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz" | tar zxf -
  fi
  PATCHES="makefile.patch debian.patch"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
fi
