set -u

rm -rf build
mkdir build
cd build || exit

EIGEN3_OPT=""
if command -v brew >/dev/null 2>&1; then
  EIGEN3_OPT="-DEIGEN3_INCLUDE_DIR=$(brew --prefix eigen)/include/eigen3"
fi

${CMAKE} -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
  -DDocumentation=OFF \
  "${EIGEN3_OPT}" \
  ../
