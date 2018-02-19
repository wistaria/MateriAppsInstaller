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

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/tapioca_$TAPIOCA_VERSION
if [ -n "$QT4_ROOT" ]; then
  patch -p1 < $SCRIPT_DIR/tapioca-intel-mkl-qt4.patch
else
  patch -p1 < $SCRIPT_DIR/tapioca-intel-mkl.patch
fi
start_info | tee -a $LOG
echo "[make tapioca]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install tapioca]" | tee -a $LOG
make install PREFIX=$PREFIX | tee -a $LOG
cp -r sample $PREFIX
cp -f src/defaults.*ml src/kpath.xml src/spacegroup.db $PREFIX/libexec
cat << EOF > $BUILD_DIR/tapioca
#!/bin/sh
$PREFIX/libexec/tapioca "$@"
exit $?
EOF
mkdir -p $PREFIX/bin
cp -f $BUILD_DIR/tapioca $PREFIX/bin
chmod +x $PREFIX/bin/tapioca
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/tapiocavars.sh
. $PREFIX_TOOL/env.sh
export XTAPP_ROOT=$XTAPP_ROOT
export TAPIOCA_ROOT=$PREFIX
export PATH=\$XTAPP_ROOT/bin:\$TAPIOCA_ROOT/bin:\$PATH
EOF
TAPIOCAVARS_SH=$PREFIX_APPS/tapioca/tapiocavars-$TAPIOCA_VERSION-$TAPIOCA_PATCH_VERSION.sh
rm -f $TAPIOCAVARS_SH
cp -f $BUILD_DIR/tapiocavars.sh $TAPIOCAVARS_SH
cp -f $LOG $PREFIX_APPS/tapioca
