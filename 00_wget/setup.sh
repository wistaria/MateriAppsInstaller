#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d wget-$WGET_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/wget-$WGET_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/wget-$WGET_VERSION.tar.gz
  else 
    check wget https://ftp.gnu.org/gnu/wget/wget-$WGET_VERSION.tar.gz
    check tar zxf wget-$WGET_VERSION.tar.gz
  fi
fi
if [ -d nettle-$NETTLE_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/nettle-$NETTLE_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/nettle-$NETTLE_VERSION.tar.gz
  else 
    check wget https://ftp.gnu.org/gnu/nettle/nettle-$NETTLE_VERSION.tar.gz
    check tar zxf nettle-$NETTLE_VERSION.tar.gz
  fi
fi
if [ -d gnutls-$GNUTLS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/gnutls-$GNUTLS_VERSION.tar.xz ]; then
    check tar Jxf $SOURCE_DIR/gnutls-$GNUTLS_VERSION.tar.xz
  else 
    check wget https://ftp.gnu.org/gnu/gnutls/gnutls-$GNUTLS_VERSION.tar.xz
    check tar Jxf gnutls-$GNUTLS_VERSION.tar.xz
  fi
fi
