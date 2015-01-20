#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
. $PREFIX_APPS/xtapp/xtappvars.sh
LOG=$BUILD_DIR/tapioca-$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/tapioca/tapioca-$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/download.sh
rm -rf $LOG
cd $BUILD_DIR/tapioca-$TAPIOCA_VERSION
if [ -n $QT4_ROOT ]; then
  patch -p1 < $SCRIPT_DIR/tapioca-intel-mkl-qt4.patch
else
  patch -p1 < $SCRIPT_DIR/tapioca-intel-mkl.patch
fi
start_info | tee -a $LOG
echo "[make tapioca]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install tapioca]" | tee -a $LOG
$SUDO_APPS make install PREFIX=$PREFIX | tee -a $LOG
$SUDO_APPS cp -r sample $PREFIX
$SUDO_APPS cp -f src/defaults.*ml src/kpath.xml src/spacegroup.db $PREFIX/libexec
cat << EOF > $BUILD_DIR/tapioca
#!/bin/sh
$PREFIX/libexec/tapioca "$@"
exit $?
EOF
$SUDO_APPS mkdir -p $PREFIX/bin
$SUDO_APPS cp -f $BUILD_DIR/tapioca $PREFIX/bin
$SUDO_APPS chmod +x $PREFIX/bin/tapioca
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/tapiocavars.sh
. $PREFIX_TOOL/env.sh
export XTAPP_ROOT=$XTAPP_ROOT
export TAPIOCA_ROOT=$PREFIX
export PATH=\$XTAPP_ROOT/bin:\$TAPIOCA_ROOT/bin:\$PATH
EOF
TAPIOCAVARS_SH=$PREFIX_APPS/tapioca/tapiocavars-$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.sh
$SUDO_APPS rm -f $TAPIOCAVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/tapiocavars.sh $TAPIOCAVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/tapioca
