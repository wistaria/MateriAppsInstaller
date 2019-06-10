#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/dsqss-$DSQSS_VERSION-$DSQSS_MA_REVISION.log

PREFIX="$PREFIX_APPS/dsqss/dsqss-$DSQSS_VERSION-$DSQSS_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/dsqss-v$DSQSS_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
echo "mkdir build && cd build" | tee -a $LOG
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCONFIG=intel ../ | tee -a $LOG

echo "[make]" | tee -a $LOG
make | tee -a $LOG

echo "[make install]" | tee -a $LOG
make install | tee -a $LOG

cd $BUILD_DIR/dsqss-v$DSQSS_VERSION

mkdir -p $PREFIX/doc
cp DSQSS_jp.pdf $PREFIX/doc
cp DSQSS_en.pdf $PREFIX/doc

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/dsqssvars.sh
# dsqss $(basename $0 .sh) $DSQSS_VERSION $DSQSS_MA_REVISION $(date +%Y%m%d-%H%M%S)
export DSQSS_ROOT=$PREFIX
source \$DSQSS_ROOT/share/dsqss/dsqssvars-${DSQSS_VERSION}.sh
EOF
DSQSSVARS_SH=$PREFIX_APPS/dsqss/dsqssvars-$DSQSS_VERSION-$DSQSS_MA_REVISION.sh
rm -f $DSQSSVARS_SH
cp -f $BUILD_DIR/dsqssvars.sh $DSQSSVARS_SH
cp -f $LOG $PREFIX_APPS/dsqss
