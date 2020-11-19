#!/bin/sh

. $SCRIPT_DIR/../../scripts/util.sh

check sh bootstrap.sh 2>&1 | tee -a $LOG
check ./b2 --prefix=$PREFIX install 2>&1 | tee -a $LOG
