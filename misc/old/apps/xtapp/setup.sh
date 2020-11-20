#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d xtapp_$XTAPP_VERSION ]; then :; else
    check tar zxf $SOURCE_DIR/xtapp_$XTAPP_VERSION.orig.tar.gz
    cd xtapp_$XTAPP_VERSION
    check tar zxf $SOURCE_DIR/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz
    PATCHES=$(cat debian/patches/series)
    for p in $PATCHES; do
	if [ $p != "debian.patch" ]; then
	    echo "Applying debian/patches/$p"
	    patch -p1 < debian/patches/$p
	fi
    done
    cp -fp src/Makefile-dist src/Makefile
    
    cd $BUILD_DIR/xtapp_$XTAPP_VERSION
    check tar zxf $SOURCE_DIR/xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz
    cd xtapp-util_$XTAPP_UTIL_VERSION
    check tar zxf $SOURCE_DIR/xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz
    PATCHES=$(cat debian/patches/series)
    for p in $PATCHES; do
	if [ $p != "debian.patch" ]; then
	    echo "Applying debian/patches/$p"
	    patch -p1 < debian/patches/$p
	fi
    done
    
    cd $BUILD_DIR/xtapp_$XTAPP_VERSION
    check tar zxf $SOURCE_DIR/xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz
fi
