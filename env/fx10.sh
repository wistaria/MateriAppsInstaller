#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
set_build_dir

cat << EOF > $BUILD_DIR/env.sh
OS=\$(uname -s)
ARCH=\$(uname -m)
PREFIX_OPT=$PREFIX_OPT
export CMAKE_PATH=\$PREFIX_OPT/bin/cmake
export CTEST_PATH=\$PREFIX_OPT/bin/ctest
export PATH=\$PREFIX_OPT/bin:\$PREFIX_OPT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$PREFIX_OPT/lib:\$PREFIX_OPT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
$SUDO mkdir -p $PREFIX_OPT $PREFIX_OPT/Linux-x86_64 $PREFIX_OPT/Linux-s64fx
$SUDO cp -f $BUILD_DIR/env.sh $PREFIX_OPT
