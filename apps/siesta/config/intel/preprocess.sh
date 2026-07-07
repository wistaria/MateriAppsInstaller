set -u

rm -rf build
mkdir build

# Intel toolchain (ifort/icc + MKL). Verified combination on ISSP ohtaka:
# oneapi_compiler/2023.0.0 + openmpi/4.1.5-oneapi-2023.0.0-classic +
# oneapi_mkl/2023.0.0, with the OpenMPI wrappers (mpicc/mpif90) driving
# the Intel compilers.
#
# SIESTA_WITH_DFTD3 and the unit tests must stay OFF with ifort classic:
# their bundled test-drive dependency fails with "Function return
# parameter requires SSE register while SSE is disabled".

if [ -z ${CC+defined} ]; then
  CC=mpicc
fi
if [ -z ${CXX+defined} ]; then
  CXX=mpicxx
fi
if [ -z ${FC+defined} ]; then
  FC=mpif90
fi
export CC CXX FC

: "${MKLROOT:?Error: MKLROOT is not set (load the MKL environment first)}"

${CMAKE} -S . -B build \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DSIESTA_WITH_MPI=ON \
  -DSIESTA_WITH_OPENMP=OFF \
  -DSIESTA_WITH_LIBXC=OFF \
  -DSIESTA_WITH_NETCDF=OFF \
  -DSIESTA_WITH_FLOOK=OFF \
  -DSIESTA_WITH_ELPA=OFF \
  -DSIESTA_WITH_ELSI=OFF \
  -DSIESTA_WITH_DFTD3=OFF \
  -DBUILD_TESTING=OFF \
  -DSIESTA_WITH_UNIT_TESTS=OFF \
  -DBLA_VENDOR=Intel10_64lp_seq \
  -DSCALAPACK_LIBRARY="${SCALAPACK_LIBRARIES:--L$MKLROOT/lib/intel64 -lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64}" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
  .
