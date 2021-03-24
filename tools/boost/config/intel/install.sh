set -u

BJAM="./tools/build/b2 --layout=system --ignore-site-config toolset=intel"

(cd tools/build && ./b2 --prefix=$PREFIX install)
. $SCRIPT_DIR/../python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam --prefix=$PREFIX install
else
  env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam --without-python --prefix=$PREFIX install
fi
