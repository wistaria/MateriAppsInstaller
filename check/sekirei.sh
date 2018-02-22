#!/bin/sh

ENV_CONF="default"
TOOL_SET="
00_wget:default
04_cmake:default
06_fftw:intel
10_hdf5:default
11_eigen3:default
20_python:intel-mkl
25_boost:intel
35_git:default
40_alpscore:intel_cxx1y
70_alps:intel-mkl
78_hphi:sekirei
"

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
MAINSTALLER_CONFIG=$HOME/.mainstaller-check
PREFIX=$HOME/materiapps-check
BUILD_DIR=$PREFIX/build

mkdir -p $PREFIX $BUILD_DIR
cat << EOF > $MAINSTALLER_CONFIG
PREFIX=$PREFIX
BUILD_DIR=$BUILD_DIR
WGET_OPTION="--no-proxy"
EOF

###

export MAINSTALLER_CONFIG
sh $SCRIPT_DIR/../00_env/$ENV_CONF.sh
cat << EOF > $PREFIX/env.d/00_local.sh
eval \`/usr/bin/modulecmd bash remove intel gnu\`
eval \`/usr/bin/modulecmd bash load intel/18.0.1.163 gnu/7.2.0\`
eval \`/usr/bin/modulecmd bash list\`
EOF
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
