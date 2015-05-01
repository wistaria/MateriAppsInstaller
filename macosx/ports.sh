port selfupdate         
port install gcc49
port select --set gcc mp-gcc49
port install openmpi-gcc49
port select --set mpi openmpi-gcc49-fortran
port install wget subversion scalapack +gcc49 +openmpi fftw-3 +gfortran
port install cmake
port install qt4-mac
port install hdf5 +threadsafe
port install python27
port select --set python python27
port install py27-scipy py27-matplotlib
port install py27-ipython py27-zmq py27-jinja2
port install py27-mpi4py +gcc49 +openmpi
port install git
