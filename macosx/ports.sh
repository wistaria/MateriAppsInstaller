port selfupdate
port -N install ld64 +ld64_xcode
port -N install gcc9 openmpi-gcc9
port select --set gcc mp-gcc9
port select --set mpi openmpi-gcc9-fortran
port -N install wget subversion cmake fftw-3 +gcc9 fftw-3-single +gcc9 gsl +gcc9
port -N install qt4-mac
port -N install hdf5 +gcc9 +threadsafe
port -N install gnuplot

port -N install python27 py27-pip py27-scipy py27-matplotlib
port select --set python python27
port select --set python2 python27
rm -f /opt/local/bin/pip /opt/local/bin/pip2
ln -s pip-2.7 /opt/local/bin/pip2
ln -s pip2 /opt/local/bin/pip
port -N install py27-virtualenv
port select --set virtualenv virtualenv27
port -N install py27-jupyter
port select --set ipython py27-ipython
port select --set ipython2 py27-ipython
port -N install py27-wxpython-2.8 py27-opengl py27-mako py27-mpi4py +gcc9 +openmpi py27-h5py +gcc9 -openmpi

port -N install python37 py37-pip py37-scipy py37-matplotlib
port select --set python3 python37
rm -f /opt/local/bin/pip3
ln -s pip-3.6 /opt/local/bin/pip3
port -N install py37-jupyter
port select --set ipython3 py37-ipython
rm -f /opt/local/bin/jupyter
ln -s jupyter-3.6 /opt/local/bin/jupyter
