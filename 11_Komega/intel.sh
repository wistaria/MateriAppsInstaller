#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/Komega-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION.log

PREFIX="$PREFIX_TOOL/Komega/Komega-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/Komega-$KOMEGA_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG

# copy library files
echo "$SUDO_TOOLS mkdir -p $PREFIX/lib" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/lib | tee -a $LOG

echo "$SUDO_TOOLS cp src/libkomega.a ${PREFIX}/lib" | tee -a $LOG
$SUDO_TOOLS cp src/libkomega.a ${PREFIX}/lib

echo "$SUDO_TOOLS cp src/shared/libkomega.so ${PREFIX}/lib" | tee -a $LOG
$SUDO_TOOLS cp src/libkomega.a ${PREFIX}/lib

echo "$SUDO_TOOLS cp src/mpi/libpkomega.a ${PREFIX}/lib" | tee -a $LOG
$SUDO_TOOLS cp src/mpi/libpkomega.a ${PREFIX}/lib

echo "$SUDO_TOOLS cp src/shared_mpi/libpkomega.so ${PREFIX}/lib" | tee -a $LOG
$SUDO_TOOLS cp src/shared_mpi/libpkomega.so ${PREFIX}/lib

# copy module files
echo "$SUDO_TOOLS mkdir -p $PREFIX/include/serial/static" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/include/serial/static | tee -a $LOG
echo "$SUDO_TOOLS cp src/*.mod $PREFIX/include/serial/static" | tee -a $LOG
$SUDO_TOOLS cp src/*.mod $PREFIX/include/serial/static | tee -a $LOG

echo "$SUDO_TOOLS mkdir -p $PREFIX/include/serial/shared" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/include/serial/shared | tee -a $LOG
echo "$SUDO_TOOLS cp src/shared/*.mod $PREFIX/include/serial/shared" | tee -a $LOG
$SUDO_TOOLS cp src/shared/*.mod $PREFIX/include/serial/shared | tee -a $LOG

echo "$SUDO_TOOLS mkdir -p $PREFIX/include/mpi/static" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/include/mpi/static | tee -a $LOG
echo "$SUDO_TOOLS cp src/mpi/*.mod $PREFIX/include/mpi/static" | tee -a $LOG
$SUDO_TOOLS cp src/mpi/*.mod $PREFIX/include/mpi/static | tee -a $LOG

echo "$SUDO_TOOLS mkdir -p $PREFIX/include/mpi/shared" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/include/mpi/shared | tee -a $LOG
echo "$SUDO_TOOLS cp src/shared_mpi/*.mod $PREFIX/include/mpi/shared" | tee -a $LOG
$SUDO_TOOLS cp src/shared_mpi/*.mod $PREFIX/include/mpi/shared | tee -a $LOG

# copy documents
echo "$SUDO_TOOLS mkdir -p ${PREFIX}/doc" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/doc | tee -a $LOG
echo "$SUDO_TOOLS cp komega.pdf ${PREFIX}/doc" | tee -a $LOG
$SUDO_TOOLS cp komega.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "$SUDO_TOOLS cp ShiftKSoft.pdf ${PREFIX}/doc" | tee -a $LOG
$SUDO_TOOLS cp ShiftKSoft.pdf ${PREFIX}/doc/ | tee -a $LOG

# copy shiftk
echo "$SUDO_TOOLS mkdir -p ${PREFIX}/bin" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/bin | tee -a $LOG
echo "$SUDO_TOOLS cp app/src/ShiftK.out $PREFIX/bin/ShiftK" | tee -a $LOG
$SUDO_TOOLS cp app/src/ShiftK.out $PREFIX/bin/ShiftK | tee -a $LOG
echo "$SUDO_TOOLS cp app/src/mpi/ShiftK.out $PREFIX/bin/pShiftK" | tee -a $LOG
$SUDO_TOOLS cp app/src/mpi/ShiftK.out $PREFIX/bin/pShiftK | tee -a $LOG

# copy samples
(cd test; make clean)
echo "$SUDO_TOOLS mkdir -p ${PREFIX}/sample" | tee -a $LOG
$SUDO_TOOLS mkdir -p $PREFIX/sample | tee -a $LOG
echo "$SUDO_TOOLS cp -r app/sample $PREFIX/sample/ShiftK" | tee -a $LOG
$SUDO_TOOLS cp -r app/sample $PREFIX/sample/ShiftK | tee -a $LOG
echo "$SUDO_TOOLS cp -r test $PREFIX/sample/Komega" | tee -a $LOG
$SUDO_TOOLS cp -r test $PREFIX/sample/Komega | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/Komegavars.sh
. $PREFIX_TOOL/env.sh
export KOMEGA_ROOT=$PREFIX
export PATH=\$KOMEGA_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$KOMEGA_ROOT/lib:\$LD_LIBRARY_PATH
EOF
KOMEGAVARS_SH=$PREFIX_TOOL/Komega/Komegavars-$KOMEGA_VERSION-$KOMEGA_PATCH_VERSION.sh
$SUDO_TOOLS rm -f $KOMEGAVARS_SH
$SUDO_TOOLS cp -f $BUILD_DIR/Komegavars.sh $KOMEGAVARS_SH
$SUDO_TOOLS cp -f $LOG $PREFIX_TOOL/Komega
