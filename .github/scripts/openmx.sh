#!/bin/sh

cd ${GITHUB_WORKSPACE}/apps/openmx
LIB="-lscalapack-openmpi -llapack -lblas -lfftw3 -lmpi -lpthread -lm -lgfortran" sh install.sh
sh runtest.sh

