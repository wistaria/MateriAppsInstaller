set -u

# GPU build using the NVIDIA (CUDA / OpenACC) port of Quantum ESPRESSO.
#
# Requires the NVHPC compilers (nvfortran / nvc) and a CUDA-aware MPI on PATH,
# e.g. `module load nvhpc openmpi_nvhpc` on an NVHPC/CUDA machine. nvfortran
# targets the GPU of the build node by default; when building on a node without
# the target GPU, pass an explicit compute capability through MA_EXTRA_FLAGS
# (for example MA_EXTRA_FLAGS="-gpu=cc80" for an A100). ScaLAPACK is turned off
# for the GPU build (the GPU eigensolvers are used instead).

rm -rf build
mkdir build
cd build

CC=${CC:-nvc}
FC=${FC:-nvfortran}
export CC
export FC

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DQE_ENABLE_CUDA=ON \
  -DQE_ENABLE_OPENACC=ON \
  -DQE_ENABLE_OPENMP=ON \
  -DQE_ENABLE_MPI=ON \
  -DQE_ENABLE_SCALAPACK=OFF \
  ..
