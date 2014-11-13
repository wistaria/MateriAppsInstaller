#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix

ENV_VERSION="1.2.0-16-2"

cat << EOF > $BUILD_DIR/env.sh
if [ -f /home/system/Env_base_$ENV_VERSION ]; then
  . /home/system/Env_base_$ENV_VERSION
elif [ -f /work/system/Env_base_$ENV_VERSION ]; then
  . /work/system/Env_base_$ENV_VERSION
fi
export CMAKE_PATH=$PREFIX_TOOL/bin/cmake
export CTEST_PATH=$PREFIX_TOOL/bin/ctest
export PATH=$PREFIX_TOOL/bin:$PREFIX_TOOL/$(uname -s)-$(uname -m)/bin:/tool/local/gcc/bin:/tool/local/bin:\$PATH
export LD_LIBRARY_PATH=$PREFIX_TOOL/lib:$PREFIX_TOOL/$(uname -s)-$(uname -m)/lib:/tool/local/gcc/lib64:/tool/local/lib:\$LD_LIBRARY_PATH
EOF
$SUDO mkdir -p $PREFIX_TOOL $PREFIX_TOOL/Linux-x86_64 $PREFIX_TOOL/Linux-s64fx
$SUDO cp -f $BUILD_DIR/env.sh $PREFIX_TOOL
