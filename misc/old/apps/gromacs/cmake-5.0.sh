# for gromacs 5.0.5
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_C_COMPILER=/opt/local/bin/mpicc -DCMAKE_CXX_COMPILER=/opt/local/bin/mpicxx -DGMX_MPI=on -DGMX_SIMD=SSE4.1 $BUILD_DIR/gromacs-$GROMACS_VERSION
