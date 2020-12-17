#!/bin/sh

TOOLS="gcc10 openssl cmake zlib git openmpi lapack libffi tcltk python2 python3 boost eigen3 fftw gsl hdf5 scalapack"

TOP_DIR=$(cd "$(dirname $0)"; cd ..; pwd)

sh $TOP_DIR/setup/setup.sh

for tool in $TOOLS; do
  sh $TOP_DIR/tools/$tool/install.sh
  sh $TOP_DIR/tools/$tool/link.sh
done

for tool in $TOOLS; do
  sh $TOP_DIR/tools/$tool/runtest.sh
done
