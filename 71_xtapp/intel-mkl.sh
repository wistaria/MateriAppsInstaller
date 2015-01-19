#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/xtapp-$XTAPP_VERSION-$XTAPP_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/xtapp/xtapp-$XTAPP_VERSION-$XTAPP_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/download.sh
rm -rf $LOG
cd $BUILD_DIR/xtapp
patch -p1 < $SCRIPT_DIR/xtapp-intel-mkl.patch
start_info | tee -a $LOG
echo "[make xtapp]" | tee -a $LOG
check make | tee -a $LOG

echo "[make xtapp-util]" | tee -a $LOG
cd $BUILD_DIR/xtapp/xtapp-util
check make | tee -a $LOG

echo "[make tapioca]" | tee -a $LOG
cd $BUILD_DIR/xtapp/tapioca-$TAPIOCA_VERSION
check make | tee -a $LOG

echo "[make install xtapp]" | tee -a $LOG
cd $BUILD_DIR/xtapp/src
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
cd $BUILD_DIR/xtapp
$SUDO_APPS cp -rp sample debian/check debian/opendx $PREFIX

echo "[make install xtapp-util]" | tee -a $LOG
cd $BUILD_DIR/xtapp/xtapp-util
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
$SUDO_APPS cp -p conv-tapp3/ppot2x vbpef2gp-lsda/vbpef2gp-lsda $PREFIX/bin

echo "[make install xtapp-ps]" | tee -a $LOG
cd $BUILD_DIR/xtapp/xtapp-ps_$XTAPP_PS_VERSION
$SUDO_APPS mkdir -p $PREFIX/pseudo-potential/PBE $PREFIX/pseudo-potential/PBE-nc $PREFIX/pseudo-potential/PBE-CAPZ
$SUDO_APPS cp -rp xTAPP-PS-PBE/* $PREFIX/pseudo-potential/PBE
$SUDO_APPS cp -rp xTAPP-PS-PBE-nc/* $PREFIX/pseudo-potential/PBE-nc
$SUDO_APPS cp -rp xTAPP-PS-CAPZ/* $PREFIX/pseudo-potential/PBE-CAPZ

echo "[make install tapioca]" | tee -a $LOG
cd $BUILD_DIR/xtapp/tapioca-$TAPIOCA_VERSION
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
$SUDO_APPS mkdir -p $PREFIX/tapica
$SUDO_APPS cp -rp sample $PREFIX/tapioca
$SUDO_APPS cp -p src/defaults.*ml src/kpath.xml src/spacegroup.db $PREFIX/libexec
cat << EOF > $BUILD_DIR/tapioca
#!/bin/sh
$PREFIX/libexec/tapioca "$@"
exit $?
EOF
chmod +x $BUILD_DIR/tapioca 
$SUDO_APPS cp -p $BUILD_DIR/tapioca $PREFIX/bin
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/xtappvars.sh
. $PREFIX_TOOL/env.sh
export XTAPP_ROOT=$PREFIX
export PATH=\$XTAPP_ROOT/bin:\$PATH
EOF
XTAPPVARS_SH=$PREFIX_APPS/xtapp/xtappvars-$XTAPP_VERSION-$XTAPP_PATCH_VERSION.sh
$SUDO_APPS rm -f $XTAPPVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/xtappvars.sh $XTAPPVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/xtapp
