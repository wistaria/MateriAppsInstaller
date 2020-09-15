#!/bin/sh

check sh bootstrap.sh | tee -a $LOG
check ./b2 --prefix=$PREFIX install | tee -a $LOG
