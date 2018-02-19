#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/openmpi-$OPENMPI_VERSION-$OPENMPI_MA_REVISION.log
PREFIX=$PREFIX_TOOL/openmpi/openmpi-$OPENMPI_VERSION-$OPENMPI_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/openmpi-$OPENMPI_VERSION
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX CC=icc CXX=icpc F77=ifort FC=ifort | tee -a $LOG
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG

cat << EOF > $BUILD_DIR/openmpivars.sh
# openmpi $(basename $0 .sh) $OPENMPI_VERSION $OPENMPI_MA_REVISION $(date +%Y%m%d-%H%M%S)
export OPENMPI_ROOT=$PREFIX
export OPENMPI_VERSION=$OPENMPI_VERSION
export OPENMPI_MA_REVISION=$OPENMPI_MA_REVISION
export PATH=\$OPENMPI_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$OPENMPI_ROOT/lib:\$LD_LIBRARY_PATH
EOF
OPENMPIVARS_SH=$PREFIX_TOOL/openmpi/openmpivars-$OPENMPI_VERSION-$OPENMPI_MA_REVISION.sh
rm -f $OPENMPIVARS_SH
cp -f $BUILD_DIR/openmpivars.sh $OPENMPIVARS_SH
rm -f $BUILD_DIR/openmpivars.sh
cp -f $LOG $PREFIX_TOOL/openmpi/
