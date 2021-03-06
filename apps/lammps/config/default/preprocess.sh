rm -rf build
mkdir build
cd build

cmake -C../cmake/presets/all_on.cmake -C../cmake/presets/nolib.cmake \
  -DBUILD_SHARED_LIBS=yes \
  -DPC_FFTW3_INCLUDE_DIRS=$FFTW_ROOT/include -DPC_FFTW3_LIBRARY_DIRS=$FFTW_ROOT/lib \
  -DCMAKE_CXX_FLAGS="-DLMP_INTEL_NO_TBB ${MA_EXTRA_FLAGS}" \
  -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../cmake
