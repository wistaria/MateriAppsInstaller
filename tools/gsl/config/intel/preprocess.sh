#!/bin/sh

. $SCRIPT_DIR/../../scripts/util.sh

check env CC=icc F77=ifort ./configure --prefix=$PREFIX 2>&1 | tee -a $LOG
