#!/bin/sh

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
cd $BUILD_DIR/HPhi-release-$HPHI_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
if [ -e makefile ]; then
    check make veryclean | tee -a $LOG
fi
check sh ./HPhiConfig.sh gcc-mac | tee -a $LOG
check awk '$1 !~ /CC/ && $1 !~ /^FLAGS/ {print}
           $1 ~ /CC/ { print "CC = cc"} 
           $1 ~ /^FLAGS/ {print "FLAGS = "}
           ' src/make.sys > src/make.sys.tmp
check mv src/make.sys.tmp src/make.sys
check make HPhi | tee -a $LOG
echo "[make install]" | tee -a $LOG

echo "$SUDO_APPS mkdir -p $PREFIX/bin" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/bin | tee -a $LOG

echo "$SUDO_APPS cp src/HPhi ${PREFIX}/bin" | tee -a $LOG
$SUDO_APPS cp src/HPhi ${PREFIX}/bin

echo "$SUDO_APPS cp -r samples ${PREFIX}" | tee -a $LOG
$SUDO_APPS cp -r samples ${PREFIX}

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
HPHIVARS_SH=$PREFIX_APPS/HPhi/HPhi-$HPHI_VERSION-$HPHI_PATCH_VERSION.sh
$SUDO_APPS rm -f $HPHIVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/HPhivars.sh $HPHIVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/HPhi
