mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DENABLE_OPENMP=ON -DENABLE_THREADS=ON -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp" ..
