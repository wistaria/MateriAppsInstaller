#!/bin/sh

SEKIREI_MODULE_VERSION="3.6.5_TLS1.2"
SEKIREI_MODULE_MA_REVISION="1"

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/python3-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION.log
PREFIX=$PREFIX_TOOL/python3/python3-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -rf $LOG

eval `/usr/bin/modulecmd bash load python/$SEKIREI_MODULE_VERSION`

echo "[venv]" | tee -a $LOG

python3 -m 'venv' $PREFIX | tee -a $LOG
source $PREFIX/bin/activate

echo "[pip]" | tee -a $LOG
pip3 install -U pip | tee -a $LOG

echo "[numpy]" | tee -a $LOG
pip3 install numpy | tee -a $LOG

echo "[scipy]" | tee -a $LOG
pip3 install scipy | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
pip3 install matplotlib | tee -a $LOG

echo "[jupyter]" | tee -a $LOG
pip3 install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
pip3 install mock | tee -a $LOG

deactivate

cat << EOF > $BUILD_DIR/python3vars.sh
# python3 $(basename $0 .sh) $SEKIREI_MODULE_VERSION $SEKIREI_MODULE_MA_REVISION $(date +%Y%m%d-%H%M%S)
export PYTHON3_ROOT=$PREFIX
export PYTHON3_VERSION=$SEKIREI_MODULE_VERSION
export PYTHON3_MA_REVISION=$SEKIREI_MODULE_MA_REVISION
export PATH=\$PYTHON3_ROOT/bin:\$PATH
EOF
PYTHON3VARS_SH=$PREFIX_TOOL/python3/python3vars-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION.sh
rm -f $PYTHON3VARS_SH
cp -f $BUILD_DIR/python3vars.sh $PYTHON3VARS_SH
rm -f $BUILD_DIR/python3vars.sh
cp -f $LOG $PREFIX_TOOL/python3/
