set -u

BJAM="./tools/build/b2 --layout=system --ignore-site-config"

(cd tools/build && ./b2 --prefix=$PREFIX install)
. $SCRIPT_DIR/../python3/find.sh

if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  PYTHON_OPTION="python=${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR}"
else
  PYTHON_OPTION="--without-python"
fi

# pch, context, coroutine, fiber, process are not supported for Apple Silicon
EXTRA_OPTIONS=
if [ $(arch) = "arm64" ]; then
  EXTRA_OPTIONS="pch=off --without-context --without-coroutine --without-fiber --without-process"
fi

env BOOST_BUILD_PATH=. ${BJAM} --toolset=gcc-15 --user-config=user-config.jam ${PYTHON_OPTION} ${EXTRA_OPTIONS} --prefix=$PREFIX install
