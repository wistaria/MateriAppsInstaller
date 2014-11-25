#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

$SUDO_TOOL mkdir -p $PREFIX_TOOL/boost
cd $PREFIX_TOOL/boost
$SUDO_TOOL rm -rf boost_$BOOST_VERSION
if [ -f $HOME/source/boost_$BOOST_VERSION.tar.bz2 ]; then
  $SUDO_TOOL tar jxf $HOME/source/boost_$BOOST_VERSION.tar.bz2 --no-same-owner --no-same-permissions
else
  check wget -O - http://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/boost_$BOOST_VERSION.tar.bz2/download | $SUDO_TOOL tar jxf - --no-same-owner --no-same-permissions
fi
cd boost_$BOOST_VERSION
cat $SCRIPT_DIR/boost_$BOOST_FCC_VERSION.patch | $SUDO_TOOL patch -p1

cat << EOF > $BUILD_DIR/boostvars.sh
export BOOST_ROOT=$PREFIX_TOOL/boost/boost_$BOOST_VERSION
EOF
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION.sh
$SUDO_TOOL rm -f $BOOSTVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/boostvars.sh $BOOSTVARS_SH
