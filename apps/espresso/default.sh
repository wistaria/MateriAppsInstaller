#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/espresso-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION.log
rm -rf $LOG

PREFIX="$PREFIX_APPS/espresso/espresso-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

start_info | tee -a $LOG
cd $BUILD_DIR/espresso-$ESPRESSO_VERSION
echo "[configure]" | tee -a $LOG
check ./configure --prefix=$PREFIX | tee -a $LOG
echo "[make]" | tee -a $LOG
check make all | tee -a $LOG
(cd pseudo; ../PW/src/generate_vdW_kernel_table.x)
(cd pseudo; ../PW/src/generate_rVV10_kernel_table.x)
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
mkdir -p $PREFIX/share
cp -rp pseudo $PREFIX/share
mkdir -p $PREFIX/share/doc
cp -p Doc/user_guide.pdf $PREFIX/share/doc
for d in $(find . -name debian -prune -o -name .pc -prune -o -name examples -print); do
  mkdir -p $PREFIX/share/examples/$d
  cp -rp $d/* $PREFIX/share/examples/$d/
  find $PREFIX/share/examples/$d -name *.in | xargs chmod 644
done
cat environment_variables | sed 's@^PREFIX=/usr@PREFIX=$ESPRESSO_ROOT@' | sed 's@^PSEUDO_DIR=$PREFIX/share/espresso/pseudo@PSEUDO_DIR=$PREFIX/share/pseudo@' > $PREFIX/share/examples/environment_variables
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/espressovars.sh
# espresso $(basename $0 .sh) $ESPRESSO_VERSION $ESPRESSO_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX_TOOL/env.sh
export ESPRESSO_ROOT=$PREFIX
export ESPRESSO_VERSION=$ESPRESSO_VERSION
export ESPRESSO_MA_REVISION=$ESPRESSO_MA_REVISION
export PATH=\$ESPRESSO_ROOT/bin:\$PATH
EOF
ESPRESSOVARS_SH=$PREFIX_APPS/espresso/espressovars-$ESPRESSO_VERSION-$ESPRESSO_MA_REVISION.sh
rm -f $ESPRESSOVARS_SH
cp -f $BUILD_DIR/espressovars.sh $ESPRESSOVARS_SH
rm -f $BUILD_DIR/espressovars.sh
cp -f $LOG $PREFIX_APPS/espresso/
