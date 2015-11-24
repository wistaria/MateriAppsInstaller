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
rm -rf LOG
cd $BUILD_DIR/dsqss-$DSQSS_VERSION
start_info | tee -a $LOG
echo "[runConfigure]" | tee -a $LOG
mv runConfigure.sh runConfigure.sh.org
awk '$0 ~ /case/ && $0 ~ /COMPILER/ {print "COMPILER=INTEL"} {print}' runConfigure.sh.org > runConfigure.sh
sh ./runConfigure.sh | tee -a $LOG

echo "[make]" | tee -a $LOG
make | tee -a $LOG

echo "WORM_HOME=$PREFIX" > wv.sh
awk '$0 !~ /^WORM_HOME/ {print}' bin/wormvars.sh >> wv.sh
mv wv.sh bin/wormvars.sh

awk '$0 !~ /^ODIR=/ {print} $0 ~ /^ODIR=/ {print "ODIR=\$OD"}' bin/inpgene >> inpgene
mv inpgene bin/inpgene
chmod +x bin/inpgene


echo "[make install]" | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX
$SUDO_APPS cp -r bin $PREFIX
$SUDO_APPS cp -r tool $PREFIX
$SUDO_APPS cp -r samples $PREFIX

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/dsqssvars.sh
# dsqss $(basename $0 .sh) $DSQSS_VERSION $DSQSS_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX/bin/wormvars.sh
EOF
DSQSSVARS_SH=$PREFIX_APPS/dsqss/dsqssvars-$DSQSS_VERSION-$DSQSS_MA_REVISION.sh
$SUDO_APPS rm -f $DSQSSVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/dsqssvars.sh $DSQSSVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/dsqss
