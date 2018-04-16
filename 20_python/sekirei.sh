#!/bin/sh

SEKIREI_MODULE_VERSION="2.7.14_TLS1.2"
SEKIREI_MODULE_MA_REVISION="1"

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

LOG=$BUILD_DIR/python-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION.log
PREFIX=$PREFIX_TOOL/python/python-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -rf $LOG

eval `/usr/bin/modulecmd bash load python/$SEKIREI_MODULE_VERSION`

VIRTUALENVROOT=$BUILD_DIR/python-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION
PVERSION=$(python2 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)

echo "[make by virtualenv]" | tee -a $LOG
pip2 install --prefix $VIRTUALENVROOT virtualenv | tee -a $LOG
env PYTHONPATH=$VIRTUALENVROOT/lib/python$PVERSION/site-packages $VIRTUALENVROOT/bin/virtualenv $PREFIX | tee -a $LOG

echo "[pip]" | tee -a $LOG
$PREFIX/bin/pip install -U pip | tee -a $LOG

echo "[numpy]" | tee -a $LOG
$PREFIX/bin/pip install numpy | tee -a $LOG

echo "[scipy]" | tee -a $LOG
$PREFIX/bin/pip install scipy | tee -a $LOG

echo "[matplotlib]" | tee -a $LOG
$PREFIX/bin/pip install matplotlib | tee -a $LOG

echo "[jupyter]" | tee -a $LOG
$PREFIX/bin/pip install sphinx jupyter | tee -a $LOG

echo "[mock]" | tee -a $LOG
$PREFIX/bin/pip install mock | tee -a $LOG

cat << EOF > $BUILD_DIR/pythonvars.sh
# python $(basename $0 .sh) $SEKIREI_MODULE_VERSION $SEKIREI_MODULE_MA_REVISION $(date +%Y%m%d-%H%M%S)
export PYTHON_ROOT=$PREFIX
export PYTHON_VERSION=$SEKIREI_MODULE_VERSION
export PYTHON_MA_REVISION=$SEKIREI_MODULE_MA_REVISION
export PATH=\$PYTHON_ROOT/bin:\$PATH
EOF
PYTHONVARS_SH=$PREFIX_TOOL/python/pythonvars-$SEKIREI_MODULE_VERSION-$SEKIREI_MODULE_MA_REVISION.sh
rm -f $PYTHON3VARS_SH
cp -f $BUILD_DIR/pythonvars.sh $PYTHONVARS_SH
rm -f $BUILD_DIR/pythonvars.sh
cp -f $LOG $PREFIX_TOOL/python/
