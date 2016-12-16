#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/mVMC-$MVMC_VERSION-$MVMC_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/mVMC/mVMC-$MVMC_VERSION-$MVMC_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/mVMC-release-$MVMC_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
if [ -e makefile ]; then
    check make veryclean | tee -a $LOG
fi
check sh ./config.sh mpich-gnu-mkl
check make mvmc | tee -a $LOG
echo "[make install]" | tee -a $LOG

echo "$SUDO_APPS mkdir -p $PREFIX/bin" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/bin | tee -a $LOG

echo "$SUDO_APPS cp src/vmc.out ${PREFIX}/bin" | tee -a $LOG
$SUDO_APPS cp src/vmc.out ${PREFIX}/bin
echo "$SUDO_APPS cp src/vmcdry.out ${PREFIX}/bin" | tee -a $LOG
$SUDO_APPS cp src/vmcdry.out ${PREFIX}/bin
echo "$SUDO_APPS cp src/ComplexUHF/src/UHF ${PREFIX}/bin" | tee -a $LOG
$SUDO_APPS cp src/ComplexUHF/src/UHF ${PREFIX}/bin

echo "$SUDO_APPS cp -r sample ${PREFIX}" | tee -a $LOG
$SUDO_APPS cp -r sample ${PREFIX}

echo "$SUDO_APPS mkdir -p ${PREFIX}/doc" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/doc | tee -a $LOG
echo "$SUDO_APPS cp userguide_jp.pdf ${PREFIX}/doc" | tee -a $LOG
$SUDO_APPS cp userguide_jp.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "$SUDO_APPS cp userguide_en.pdf ${PREFIX}/doc" | tee -a $LOG
$SUDO_APPS cp userguide_en.pdf ${PREFIX}/doc/ | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/mVMCvars.sh
. $PREFIX_TOOL/env.sh
export MVMC_ROOT=$PREFIX
export PATH=\$MVMC_ROOT/bin:\$PATH
EOF
MVMCVARS_SH=$PREFIX_APPS/mVMC/mVMCvars-$MVMC_VERSION-$MVMC_PATCH_VERSION.sh
$SUDO_APPS rm -f $MVMCVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/mVMCvars.sh $MVMCVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/mVMC
