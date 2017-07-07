
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/HPhi-$HPHI_VERSION-$HPHI_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/HPhi/HPhi-$HPHI_VERSION-$HPHI_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/HPhi-$HPHI_VERSION
start_info | tee -a $LOG

echo "sed -i -e 's/key2lower key2lower.c/key2lower STATIC key2lower.c/' tool/CMakeLists.txt" >> $LOG
sed -i -e 's/key2lower key2lower.c/key2lower STATIC key2lower.c/' tool/CMakeLists.txt

rm -rf build
mkdir build
cd build
echo "cmake -DCONFIG=gcc -DCMAKE_INSTALL_PREFIX=$PREFIX" | tee -a $LOG
check cmake -DCONFIG=gcc -DCMAKE_INSTALL_PREFIX=$PREFIX ../ | tee -a $LOG
echo "[make]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
cd ../

echo "$SUDO_APPS mkdir -p ${PREFIX}/doc" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/doc | tee -a $LOG
echo "$SUDO_APPS cp userguide_jp.pdf ${PREFIX}/doc" | tee -a $LOG
$SUDO_APPS cp userguide_jp.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "$SUDO_APPS cp userguide_en.pdf ${PREFIX}/doc" | tee -a $LOG
$SUDO_APPS cp userguide_en.pdf ${PREFIX}/doc/ | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/HPhivars.sh
. $PREFIX_TOOL/env.sh
export HPHI_ROOT=$PREFIX
export PATH=\$HPHI_ROOT/bin:\$PATH
EOF
HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhivars-$HPHI_VERSION-$HPHI_PATCH_VERSION.sh
$SUDO_APPS rm -f $HPHIVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/HPhivars.sh $HPHIVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/HPhi

