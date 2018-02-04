port selfupdate         
port -N install ld64 +ld64_xcode
port -N install gcc7 openmpi-gcc7
port select --set gcc mp-gcc7
port select --set mpi openmpi-gcc7-fortran
port -N install wget subversion scalapack +gcc7 +openmpi fftw-3 +gfortran fftw-3-single +gfortran gsl +gcc7
port -N install qt4-mac
port -N install hdf5 +threadsafe
port -N install gnuplot

port -N install python27 py27-pip py27-scipy py27-matplotlib
port select --set python python27
port select --set python2 python27
port -N install py27-virtualenv
port select --set virtualenv virtualenv27
port -N install py27-jupyter
port select --set ipython py27-ipython
port select --set ipython2 py27-ipython
port -N install py27-wxpython-2.8 py27-opengl

port -N install python36 py36-pip py36-scipy py36-matplotlib
port select --set python3 python36
port -N install py36-virtualenv
port -N install py36-jupyter
port select --set ipython3 py36-ipython
