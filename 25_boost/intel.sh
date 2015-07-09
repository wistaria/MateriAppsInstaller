#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.log
PREFIX=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION

$SUDO_TOOL /bin/true
sh $SCRIPT_DIR/setup.sh

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION/tools/build
check sh bootstrap.sh -with-toolset=intel-linux | tee -a $LOG
$SUDO_TOOL ./b2 --prefix=$PREFIX install | tee -a $LOG
$SUDO_TOOL rm -rf tools/build

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION
for m in mpiicpc mpicxx mpic++ mpiCC; do
  mc=$(which $m 2> /dev/null)
  test -n "$mc" && break
done
echo "using mpi : $mc : <find-shared-library> ;" > user-config.jam
check env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=tagged toolset=intel stage | tee -a $LOG
$SUDO_TOOL env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=tagged toolset=intel install | tee -a $LOG

cat << EOF > $BUILD_DIR/boostvars.sh
# boost $(basename $0 .sh) $BOOST_VERSION $BOOST_MA_REVISION $(date +%Y%m%d-%H%M%S)
export BOOST_ROOT=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION
export BOOST_VERSION=$BOOST_VERSION
export BOOST_MA_REVISION=$BOOST_MA_REVISION
export PATH=\$BOOST_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$BOOST_ROOT/lib:\$LD_LIBRARY_PATH
EOF
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.sh
$SUDO_TOOL rm -f $BOOSTVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/boostvars.sh $BOOSTVARS_SH
rm -f $BUILD_DIR/boostvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/boost/
