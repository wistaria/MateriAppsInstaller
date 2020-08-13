#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $SOURCE_DIR
if [ -f xtapp_$XTAPP_VERSION.orig.tar.gz ]; then :; else
  check wget $MALIVE_REPOSITORY/xtapp_$XTAPP_VERSION.orig.tar.gz
fi
if [ -f xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz ]; then :; else
  check wget $MALIVE_REPOSITORY/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz
fi
if [ -f xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz ]; then :; else
  check wget $MALIVE_REPOSITORY/xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz
fi
if [ -f xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz ]; then :; else
  check wget $MALIVE_REPOSITORY/xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz
fi
if [ -f xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz ]; then :; else
  check wget $MALIVE_REPOSITORY/xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz
fi
