#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.log
PREFIX=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION/tools/build
check sh bootstrap.sh | tee -a $LOG
./b2 --prefix=$PREFIX install | tee -a $LOG
rm -rf tools/build

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_MA_REVISION
echo "using mpi : $(which mpicxx) ;" > user-config.jam
check env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=system stage | tee -a $LOG
env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=system install | tee -a $LOG

cat << EOF > $BUILD_DIR/boostvars.sh
# boost $(basename $0 .sh) $BOOST_VERSION $BOOST_MA_REVISION $(date +%Y%m%d-%H%M%S)
export BOOST_ROOT=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION
export BOOST_VERSION=$BOOST_VERSION
export BOOST_MA_REVISION=$BOOST_MA_REVISION
export PATH=\$BOOST_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$BOOST_ROOT/lib:\$LD_LIBRARY_PATH
EOF
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_MA_REVISION.sh
rm -f $BOOSTVARS_SH
cp -f $BUILD_DIR/boostvars.sh $BOOSTVARS_SH
rm -f $BUILD_DIR/boostvars.sh
cp -f $LOG $PREFIX_TOOL/boost/
