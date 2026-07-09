set -u

# Out-of-source CMake build. TurboRVB (Fortran + C) auto-detects the compiler
# (GNU / Intel oneAPI / NVHPC / ...) and picks its own optimization flags per
# compiler, so we only pass the install prefix and the optional user flags.
#
# BLAS/LAPACK are found with find_package (or Intel MKL when available). MPI is
# found with find_package(MPI); if MPI is missing CMake automatically turns the
# parallel build off, so EXT_PARALLEL is left at its default (ON) and the MPI
# executables (turborvb-mpi.x, ...) are produced only when an MPI Fortran
# compiler is present. Set CC / FC in ~/.mainstaller or the environment to
# choose a specific compiler (CMake honours the CC / FC variables).

rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  ../
