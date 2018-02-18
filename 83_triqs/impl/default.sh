#!/bin/sh

LOG=$BUILD_DIR/triqs-$TRIQS_VERSION-$TRIQS_PATCH_VERSION.log
PREFIX="$PREFIX_TOOL/triqs/triqs-$TRIQS_VERSION-$TRIQS_PATCH_VERSION"
BUILD_DIR_TRIQS=$BUILD_DIR/triqs-build-$TRIQS_VERSION
SRC_DIR_TRIQS=$BUILD_DIR/triqs-$TRIQS_VERSION-$TRIQS_PATCH_VERSION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
if [ -d $BUILD_DIR_TRIQS ]; then
  rm -rf $BUILD_DIR_TRIQS
fi
mkdir -p $BUILD_DIR_TRIQS
cd $BUILD_DIR_TRIQS
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx \
  $SRC_DIR_TRIQS | tee -a $LOG

echo "[make]" | tee -a $LOG
check make -j2 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/triqsvars.sh
export TRIQS_ROOT=$PREFIX
export TRIQS_DIR=$PREFIX
export LD_LIBRARY_PATH=\$TRIQS_ROOT/lib:\$LD_LIBRARY_PATH
export PATH=\$TRIQS_ROOT/bin:\$PATH
EOF
TRIQSVARS_SH=$PREFIX_TOOL/triqs/triqsvars-$TRIQS_VERSION-$TRIQS_PATCH_VERSION.sh
$SUDO_TOOL rm -f $TRIQSVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/triqsvars.sh $TRIQSVARS_SH
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/triqs/
