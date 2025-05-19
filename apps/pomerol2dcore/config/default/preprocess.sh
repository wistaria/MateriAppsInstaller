rm -rf build; mkdir build; cd build

cmake -DCMAKE_BUILD_TYPE=Release \
  -Dpomerol_DIR=${POMEROL_ROOT}/share/pomerol \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../
