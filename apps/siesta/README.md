# SIESTA

**UNSUPPORTED**: this package is provided as-is. It is not covered by the
MateriApps Installer CI and is not officially supported by the MateriApps
team. Use at your own risk and report problems to the package contributor,
not to the SIESTA developers.

- <https://siesta-project.org/>
- A first-principles electronic structure code based on numerical atomic
  orbitals (DFT, order-N capable), including TranSIESTA/TBtrans transport.

## Requirements

- CMake >= 3.20, pkg-config, a Fortran/C compiler, MPI, BLAS/LAPACK, ScaLAPACK
- Network access during `install.sh`: SIESTA 5.x downloads internal
  libraries (libfdf, xmlf90, libpsml, libgridxc) at configure time
- If ScaLAPACK is not found automatically, pass it explicitly:
  `SCALAPACK_LIBRARIES="-L/path/to/lib -lscalapack" sh install.sh`

## Notes

- The build is pure MPI (OpenMP disabled). netCDF, libxc, ELSI/ELPA,
  flook, and DFT-D3 are disabled in the shipped configs; edit
  `config/*/preprocess.sh` to enable them (DFT-D3 and the unit tests do
  not compile with Intel ifort classic — keep them off there).
- `config/intel` assumes Intel compilers behind OpenMPI wrappers with MKL
  (`MKLROOT` must be set); this combination is verified on ISSP ohtaka.
- `runtest.sh` runs the bundled H2O example serially/1 MPI process.
