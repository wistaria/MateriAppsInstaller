cat << EOF > platforms/kugui-prgenv-intel.cmake
### Intel Compiler for Haswell, Broadwell...
set(ARCH_FLAGS                  "-march=core-avx2")
set(OPENMP_FLAGS                "-qopenmp")
set(LAPACK_VENDOR_FLAGS         "-lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm")
set(ScaLAPACK_VENDOR_FLAGS      "-lmkl_scalapack_lp64 -lmkl_blacs_intelmpi_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liopm5 -lpthread -lm")
set(Fortran_PP_FLAGS            "-fpp")

set(CMAKE_Fortran_COMPILER      "ftn")
set(CMAKE_C_COMPILER            "cc")

set(General_Fortran_FLAGS       "-nogen-interface -std03 -warn all -diag-disable 6477,7025 -ansi-alias -fno-alias -qoverride-limits")
set(General_C_FLAGS             "-Wall -restrict -ansi-alias -fno-alias")
set(CMAKE_Fortran_FLAGS_DEBUG   "-O2 -g ${General_Fortran_FLAGS}")
set(CMAKE_C_FLAGS_DEBUG         "-O2 -g ${General_C_FLAGS}")
set(CMAKE_Fortran_FLAGS_RELEASE "-O3 ${General_Fortran_FLAGS}")
set(CMAKE_C_FLAGS_RELEASE       "-O3 ${General_C_FLAGS}")

set(USE_MPI_DEFAULT             ON)

########
# CMake Platform-specific variables
########
set(CMAKE_SYSTEM_NAME "Linux" CACHE STRING "ISSP Supercomputer Kugui")
set(CMAKE_SYSTEM_PROCESSOR "avx2")
EOF

rm -rf build
mkdir build
cd build

python3 ../configure.py --arch=kugui-prgenv-intel --prefix=${PREFIX} --verbose
