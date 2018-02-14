#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/wget-$WGET_VERSION-$WGET_MA_REVISION.log
PREFIX=$PREFIX_TOOL/wget/wget-$WGET_VERSION-$WGET_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/nettle-$NETTLE_VERSION
echo "[make nettle]" | tee -a $LOG
check ./configure --prefix=$PREFIX | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install nettle]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG

cd $BUILD_DIR/gnutls-$GNUTLS_VERSION
echo "[make gnutls]" | tee -a $LOG
check ./configure --prefix=$PREFIX --with-libnettle-prefix=$PREFIX --disable-guile | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install gnutls]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG

cd $BUILD_DIR/wget-$WGET_VERSION
echo "[make wget]" | tee -a $LOG
check ./configure --prefix=$PREFIX GNUTLS_CFLAGS="-I$PREFIX/include" GNUTLS_LIBS="-L$PREFIX/lib -lgnutls" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install wget]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG

cat << EOF > $BUILD_DIR/wgetvars.sh
# wget $(basename $0 .sh) $WGET_VERSION $WGET_MA_REVISION $(date +%Y%m%d-%H%M%S)
export WGET_ROOT=$PREFIX
export WGET_VERSION=$WGET_VERSION
export WGET_MA_REVISION=$WGET_MA_REVISION
export PATH=\$WGET_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$WGET_ROOT/lib64:\$WGET_ROOT/lib:\$LD_LIBRARY_PATH
EOF
WGETVARS_SH=$PREFIX_TOOL/wget/wgetvars-$WGET_VERSION-$WGET_MA_REVISION.sh
$SUDO_TOOL rm -f $WGETVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/wgetvars.sh $WGETVARS_SH
rm -f $BUILD_DIR/wgetvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/wget/
