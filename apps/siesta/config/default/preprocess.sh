set -u

rm -rf build
mkdir build

# SIESTA 5.x downloads some internal libraries (libfdf, xmlf90, libpsml,
# libgridxc) at configure time, so network access is required here.
#
# DFT-D3 and the unit tests are disabled because their bundled test-drive
# dependency does not compile with Intel ifort classic; both are kept off
# in every mode for consistency.
#
# The two cmake invocations below must stay identical except for the
# trailing -DSCALAPACK_LIBRARY option.

if [ -z "${SCALAPACK_LIBRARIES}" ]; then
  echo "SCALAPACK_LIBRARIES is not set; relying on CMake auto-detection."
  echo "If configuration fails, retry with e.g. SCALAPACK_LIBRARIES=\"-L/path/to/lib -lscalapack\""
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
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
    .
else
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
    -DSCALAPACK_LIBRARY="${SCALAPACK_LIBRARIES}" \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
    .
fi
