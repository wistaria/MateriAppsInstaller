#!/bin/sh

ENV_CONF="default"
TOOL_SET="
01_gcc7:default
03_openmpi:default
04_cmake:default
06_fftw:default
10_hdf5:default
11_eigen3:default
11_komega:default
20_python:default
21_python3:default
25_boost:default
35_git:default
40_alpscore:default_cxx1y
70_alps:default
78_hphi:default
83_triqs:default_cxx1y
"

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
MAINSTALLER_CONFIG=$HOME/.mainstaller-check-gcc
PREFIX=$HOME/materiapps-check-gcc
BUILD_DIR=$PREFIX/build

mkdir -p $PREFIX $BUILD_DIR
cat << EOF > $MAINSTALLER_CONFIG
PREFIX=$PREFIX
BUILD_DIR=$BUILD_DIR
EOF

###

export MAINSTALLER_CONFIG
sh $SCRIPT_DIR/../00_env/$ENV_CONF.sh
for s in $TOOL_SET; do
  dirc=$(echo $s | cut -d: -f1)
  tool=$(echo $dirc | sed 's/^[0-9][0-9]_//')
  conf=$(echo $s | cut -d: -f2)
  if [ -d $PREFIX/$tool ]; then :; else
    echo "[$dirc, $tool, $conf]"
    sh $SCRIPT_DIR/../$dirc/$conf.sh && sh $SCRIPT_DIR/../$dirc/link.sh
  fi
done

###

source $PREFIX/env.sh
check_maversion
