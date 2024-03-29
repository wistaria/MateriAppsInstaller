set -u

BJAM="./tools/build/b2 --layout=system --ignore-site-config"

(cd tools/build && ./b2 --prefix=$PREFIX install)
. $SCRIPT_DIR/../python3/find.sh

if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  PYTHON_OPTION="python=${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR}"
else
  PYTHON_OPTION="--without-python"
fi

env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam ${PYTHON_OPTION} --prefix=$PREFIX install
