rm -rf build; mkdir build; cd build

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DEIGEN3_INCLUDE_DIR=${EIGEN3_ROOT}/include/eigen3 \
  -DPOMEROL_COMPLEX_MATRIX_ELEMENTS=ON \
  ../
