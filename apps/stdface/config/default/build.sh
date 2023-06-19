set -u

for MODE in HPHI MVMC HWAVE; do
  rm -rf build
  mkdir build
  cd build

  ${CMAKE} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG" \
    -DCMAKE_VERBOSE_MAKEFILE=1 \
    -D${MODE}=ON \
    ../

  make ${MAKE_J}
  make install
  cd ../
done
