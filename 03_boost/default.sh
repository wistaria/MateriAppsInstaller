#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_PATCH_VERSION

$SUDO_TOOL /bin/true
sh $SCRIPT_DIR/setup.sh

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_PATCH_VERSION/tools/build
check sh bootstrap.sh
$SUDO_TOOL ./b2 --prefix=$PREFIX install

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_PATCH_VERSION
echo "using mpi : $(which mpicxx) ;" > user-config.jam
check env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX stage
$SUDO_TOOL env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX install

cat << EOF > $BUILD_DIR/boostvars.sh
export BOOST_ROOT=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_PATCH_VERSION
export BOOST_VERSION=$BOOST_VERSION
export BOOST_PATCH_VERSION=$BOOST_PATCH_VERSION
export PATH=\$BOOST_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$BOOST_ROOT/lib:\$LD_LIBRARY_PATH
EOF
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_PATCH_VERSION.sh
$SUDO_TOOL rm -f $BOOSTVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/boostvars.sh $BOOSTVARS_SH
