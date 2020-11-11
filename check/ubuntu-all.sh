#!/bin/sh

TOOLS="gcc10:default openssl:default cmake:default zlib:default git:default boost:default eigen3:default fftw:default gsl:default hdf5:default libffi:default "

TOP_DIR=$(cd "$(dirname $0)"; cd ..; pwd)

bash $TOP_DIR/setup/setup.sh

for tool in $TOOLS; do
  name=$(echo $tool | cut -d: -f1)
  conf=$(echo $tool | cut -d: -f2)
  bash $TOP_DIR/tools/$name/install.sh $conf
  bash $TOP_DIR/tools/$name/link.sh
done
