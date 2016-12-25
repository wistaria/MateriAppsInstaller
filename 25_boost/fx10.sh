#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version-fx10.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.log
PREFIX=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
PREFIX_BACKEND="$PREFIX/Linux-s64fx"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup-fx10.sh
rm -rf $LOG

start_info | tee -a $LOG

echo "[boost build]" | tee -a $LOG
check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION/tools/build/v2
check sh bootstrap.sh | tee -a $LOG
$SUDO_TOOL ./b2 --prefix=$PREFIX_FRONTEND toolset=gcc install | tee -a $LOG
rm -rf b2 bjam bin bootstrap.log engine/bin.* engine/bootstrap

echo "[boost x86_64]" | tee -a $LOG
check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION
check env BOOST_BUILD_PATH=. $PREFIX_FRONTEND/bin/b2 -j4 -d2 --prefix=$PREFIX_FRONTEND --layout=tagged --without-graph_parallel --without-mpi toolset=gcc threading=multi variant=release stage | tee -a $LOG
$SUDO_TOOL env BOOST_BUILD_PATH=. $PREFIX_FRONTEND/bin/b2 -j4 -d2 --prefix=$PREFIX_FRONTEND --layout=tagged --without-graph_parallel --without-mpi toolset=gcc threading=multi variant=release install | tee -a $LOG
check rm -rf bin.v2 stage

echo "[boost s64fx]" | tee -a $LOG
check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION
echo "using mpi : $(which mpiFCCpx) ;" > tools/build/v2/user-config.jam
check env BOOST_BUILD_PATH=. $PREFIX_FRONTEND/bin/b2 -j4 -d2 --prefix=$PREFIX_BACKEND --layout=tagged --without-context --without-coroutine --without-python toolset=fccx threading=multi variant=release stage | tee build-stage.log
cat build-stage.log >> $LOG

DIRS=$(cd bin.v2/libs && ls)
echo "(grep FCCpx build-stage.log | grep '\-shared' | \\" > fix-stage.sh
for d in $DIRS; do
  echo "sed 's#bin.v2/libs/$d/build/fccx/release/threading-multi/libboost#libboost#' | \\" >> fix-stage.sh
done
echo "sed 's#bin.v2/libs/log/build/fccx/release/build-no/log-api-unix/threading-multi/libboost#libboost#' | \\" >> fix-stage.sh
echo "sh -x)" >> fix-stage.sh
echo "Fixing shared library search path..." | tee -a $LOG
sh fix-stage.sh | tee -a $LOG
mv -f libboost_* stage/lib/
grep '^    cp' build-stage.log  | grep 'release/threading-multi' | awk '{print $1,$3,$2}' | sh -x | tee -a $LOG

$SUDO_TOOL env BOOST_BUILD_PATH=. $PREFIX_FRONTEND/bin/b2 -j4 -d2 --prefix=$PREFIX_BACKEND --layout=tagged --without-context --without-coroutine --without-python toolset=fccx threading=multi variant=release install | tee -a $LOG
check rm -rf bin.v2 stage

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/boostvars.sh
# boost $(basename $0 .sh) $BOOST_VERSION $BOOST_MA_REVISION $(date +%Y%m%d-%H%M%S)
OS=\$(uname -s)
ARCH=\$(uname -m)
export BOOST_ROOT=$PREFIX
export BOOST_VERSION=$BOOST_VERSION
export BOOST_MA_REVISION=$BOOST_MA_REVISION
export PATH=\$BOOST_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$BOOST_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.sh
$SUDO_TOOL rm -f $BOOSTVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/boostvars.sh $BOOSTVARS_SH
rm -f $BUILD_DIR/boostvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/boost/
