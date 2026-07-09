#!/bin/sh
set -e

# ALAMODE needs Boost, Eigen3 and spglib in addition to the FFTW3 / LAPACK / MPI
# provided by the shared CI setup. Install them from the system packages and
# point the build at the system spglib and FFTW3 (config/default/preprocess.sh
# expects SPGLIB_ROOT and FFTW3_ROOT to be set, as provided on ohtaka by the
# MateriApps spglib / fftw tools).
sudo apt-get -y install libboost-dev libeigen3-dev libsymspg-dev

export SPGLIB_ROOT=/usr
export FFTW3_ROOT=/usr

cd ${GITHUB_WORKSPACE}/apps/alamode
MAKE_J=-j4 sh install.sh
sh runtest.sh
