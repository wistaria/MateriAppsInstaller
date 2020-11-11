#!/bin/sh

. $SCRIPT_DIR/../../scripts/util.sh

check ./configure CC=icc F77=ifort --prefix=$PREFIX --enable-shared --enable-threads --enable-avx 2>&1 | tee -a $LOG
