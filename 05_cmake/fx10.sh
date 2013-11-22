#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh
PREFIX_FRONTEND="$PREFIX_OPT/Linux-x86_64"
PREFIX_BACKEND="$PREFIX_OPT/Linux-s64fx"
CMAKE_VERSION_MAJOR=$(echo "$CMAKE_VERSION" | cut -d . -f 1,2)

cd $BUILD_DIR
rm -rf cmake-$CMAKE_VERSION cmake-$CMAKE_VERSION-Linux-x86_64 cmake-$CMAKE_VERSION-Linux-s64fx
if [ -f $HOME/source/cmake-$CMAKE_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/cmake-$CMAKE_VERSION.tar.gz
else
  check wget -O - http://www.cmake.org/files/v$CMAKE_VERSION_MAJOR/cmake-$CMAKE_VERSION.tar.gz | tar zxf -
fi
check rm -rf cmake-$CMAKE_VERSION-Linux-x86_64
check mkdir -p cmake-$CMAKE_VERSION-Linux-x86_64
check cd cmake-$CMAKE_VERSION-Linux-x86_64
check $BUILD_DIR/cmake-$CMAKE_VERSION/bootstrap --prefix=$PREFIX_FRONTEND
check make -j4
$SUDO make install

cd $BUILD_DIR
check rm -rf cmake-$CMAKE_VERSION-Linux-s64fx
check mkdir -p cmake-$CMAKE_VERSION-Linux-s64fx
check cd cmake-$CMAKE_VERSION-Linux-s64fx
CC="fccpx -Xg" CFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" CXX="FCCpx -Xg" CXXFLAGS="-O2 -DcmIML_ABI_NO_ERROR_LONG_LONG" $PREFIX_FRONTEND/bin/cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_BACKEND -DUPDATE_TYPE=svn -DHAVE_FCHDIR=1 -DHAVE_FCHMOD=1 -DHAVE_FCHOWN=1 -DHAVE_FCNTL=1 -DHAVE_UTIMES=1 check $BUILD_DIR/cmake-$CMAKE_VERSION
check make ctest cpack ccmake cmake
check $PREFIX_FRONTEND/bin/ctest --help-full Docs/ctest.txt --help-full Docs/ctest.html --help-full Docs/ctest.1 --help-full Docs/ctest.docbook
check $PREFIX_FRONTEND/bin/cpack --help-full Docs/cpack.txt --help-full Docs/cpack.html --help-full Docs/cpack.1 --help-full Docs/cpack.docbook
check $PREFIX_FRONTEND/bin/ccmake --help-full Docs/ccmake.txt --help-full Docs/ccmake.html --help-full Docs/ccmake.1 --help-full Docs/ccmake.docbook
check $PREFIX_FRONTEND/bin/cmake --copyright Docs/Copyright.txt --help-full Docs/cmake.txt --help-full Docs/cmake.html --help-full Docs/cmake.1 --help-full Docs/cmake.docbook --help-policies Docs/cmake-policies.txt --help-policies Docs/cmake-policies.html --help-policies Docs/cmakepolicies.1 --help-properties Docs/cmake-properties.txt --help-properties Docs/cmake-properties.html --help-properties Docs/cmakeprops.1 --help-variables Docs/cmake-variables.txt --help-variables Docs/cmake-variables.html --help-variables Docs/cmakevars.1 --help-modules Docs/cmake-modules.txt --help-modules Docs/cmake-modules.html --help-modules Docs/cmakemodules.1 --help-commands Docs/cmake-commands.txt --help-commands Docs/cmake-commands.html --help-commands Docs/cmakecommands.1 --help-compatcommands Docs/cmake-compatcommands.txt --help-compatcommands Docs/cmake-compatcommands.html --help-compatcommands Docs/cmakecompat.1
check $PREFIX_FRONTEND/bin/cmake -P cmake_install.cmake

cat << EOF > $BUILD_DIR/cmake
#!/bin/sh
OS=\$(uname -s)
ARCH=\$(uname -m)
COMMAND=\$(basename \$0)
PREFIX_OPT=$PREFIX_OPT
\$PREFIX_OPT/\$OS-\$ARCH/bin/\$COMMAND "\$@"
EOF
check $SUDO mkdir -p $PREFIX_OPT/bin
check $SUDO cp -f $BUILD_DIR/cmake $PREFIX_OPT/bin/cmake
check $SUDO cp -f $BUILD_DIR/cmake $PREFIX_OPT/bin/ctest
check $SUDO chmod +x $PREFIX_OPT/bin/cmake $PREFIX_OPT/bin/ctest
