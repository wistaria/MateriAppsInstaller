#!/bin/sh

. $SCRIPT_DIR/../../scripts/util.sh

check sh bootstrap.sh -with-toolset=intel-linux | tee -a $LOG
check ./b2 --prefix=$PREFIX install | tee -a $LOG
