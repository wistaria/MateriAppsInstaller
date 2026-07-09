set -u

# GPU build via the KOKKOS package with the CUDA backend.
#
# KOKKOS needs the target GPU architecture at configure time (nvcc cross-compiles
# for a specific compute capability). Set KOKKOS_ARCH to your GPU's Kokkos
# architecture name, e.g.:
#   AMPERE80 (A100)   VOLTA70 (V100)    HOPPER90 (H100)
#   ADA89    (RTX 40) TURING75 (T4/RTX 20) PASCAL60 (P100)
# See https://kokkos.org for the full list. There is no safe default because a
# wrong architecture produces binaries that will not run on the GPU.
: "${KOKKOS_ARCH:?set KOKKOS_ARCH to your GPU Kokkos arch, e.g. AMPERE80 for A100, VOLTA70 for V100, HOPPER90 for H100, TURING75, ADA89, or PASCAL60, then re-run}"

rm -rf build
mkdir build
cd build

# nvcc_wrapper (Kokkos' CUDA host-compiler wrapper) ships with LAMMPS and must
# be used as the C++ compiler for the CUDA backend. nvcc and an MPI C++ compiler
# must be on PATH (e.g. a CUDA toolkit module + a CUDA-aware MPI).
NVCC_WRAPPER=$(cd .. && pwd)/lib/kokkos/bin/nvcc_wrapper

# Same package set as the default build (all_on minus the external-library
# packages), but GPU-accelerated through KOKKOS. The stand-alone GPU package is
# disabled so KOKKOS is the single GPU backend.
cmake -C../cmake/presets/all_on.cmake -C../cmake/presets/nolib.cmake \
  -DPKG_GPU=OFF -DPKG_KOKKOS=ON \
  -DKokkos_ENABLE_CUDA=ON -DKokkos_ENABLE_OPENMP=yes \
  -DKokkos_ARCH_${KOKKOS_ARCH}=ON \
  -DCMAKE_CXX_COMPILER=${NVCC_WRAPPER} -DCMAKE_CXX_STANDARD=17 \
  -DBUILD_SHARED_LIBS=yes \
  -DPC_FFTW3_INCLUDE_DIRS=$FFTW_ROOT/include -DPC_FFTW3_LIBRARY_DIRS=$FFTW_ROOT/lib \
  -DCMAKE_CXX_FLAGS="-DLMP_INTEL_NO_TBB ${MA_EXTRA_FLAGS}" \
  -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../cmake
