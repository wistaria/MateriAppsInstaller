
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
echo "[make]" | tee -a $LOG
if [ -e makefile ]; then
    check make veryclean | tee -a $LOG
fi
check sh ./HPhiconfig.sh maki
check make HPhi | tee -a $LOG
echo "[make install]" | tee -a $LOG

echo "mkdir -p $PREFIX/bin" | tee -a $LOG
mkdir -p $PREFIX/bin | tee -a $LOG

echo "cp src/HPhi ${PREFIX}/bin" | tee -a $LOG
cp src/HPhi ${PREFIX}/bin
echo "cp tool/fourier ${PREFIX}/bin" | tee -a $LOG
cp tool/fourier ${PREFIX}/bin
echo "cp tool/corplot ${PREFIX}/bin" | tee -a $LOG
cp tool/corplot ${PREFIX}/bin

echo "cp -r samples ${PREFIX}" | tee -a $LOG
cp -r samples ${PREFIX}

echo "mkdir -p ${PREFIX}/doc" | tee -a $LOG
mkdir -p $PREFIX/doc | tee -a $LOG
echo "cp userguide_jp.pdf ${PREFIX}/doc" | tee -a $LOG
cp userguide_jp.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "cp userguide_en.pdf ${PREFIX}/doc" | tee -a $LOG
cp userguide_en.pdf ${PREFIX}/doc/ | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/HPhivars.sh
. $PREFIX_TOOL/env.sh
export HPHI_ROOT=$PREFIX
export PATH=\$HPHI_ROOT/bin:\$PATH
EOF
HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhivars-$HPHI_VERSION-$HPHI_PATCH_VERSION.sh
rm -f $HPHIVARS_SH
cp -f $BUILD_DIR/HPhivars.sh $HPHIVARS_SH
cp -f $LOG $PREFIX_APPS/HPhi

