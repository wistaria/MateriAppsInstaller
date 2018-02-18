#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

SRC_DIR_TRIQS=$BUILD_DIR/triqs-$TRIQS_VERSION-$TRIQS_PATCH_VERSION

cd $BUILD_DIR
if [ -d $SRC_DIR_TRIQS ]; then
  rm -rf $SRC_DIR_TRIQS
fi

#if [ -f $SOURCE_DIR/triqs_$TRIQS_VERSION.orig.tar.gz ]; then
  #cp $SOURCE_DIR/triqs_$TRIQS_VERSION.orig.tar.gz triqs_$TRIQS_VERSION.orig.tar.gz
#fi

if [ -f triqs_$TRIQS_VERSION.orig.tar.gz ]; then :; else
  check wget -O triqs_$TRIQS_VERSION.orig.tar.gz https://github.com/TRIQS/triqs/archive/$TRIQS_VERSION.tar.gz
fi
check mkdir $SRC_DIR_TRIQS
check tar zxf triqs_$TRIQS_VERSION.orig.tar.gz -C $SRC_DIR_TRIQS --strip-components=1
#mv triqs-master $SRC_DIR_TRIQS

cd $SRC_DIR_TRIQS
echo $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch
if [ -f $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch ]; then
  echo "Patching "  $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch
  patch -p1 < $SCRIPT_DIR/triqs-$TRIQS_VERSION.patch
fi
