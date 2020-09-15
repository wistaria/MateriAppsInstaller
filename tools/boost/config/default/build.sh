#!/bin/sh

BJAM="$PREFIX/bin/b2 --layout=system --ignore-site-config"

# setup config files

echo "using mpi : $(which mpicxx) ;" > user-config.jam
. $SCRIPT_DIR/../python/find.sh
if [ ${MA_HAVE_PYTHON2} = "yes" ]; then
  cp user-config.jam user-config-python2.jam
  echo "using python : ${MA_PYTHON2_VERSION_MAJOR}.${MA_PYTHON2_VERSION_MINOR} : ${MA_PYTHON2} ;" >> user-config-python2.jam
fi
. $SCRIPT_DIR/../python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  cp user-config.jam user-config-python3.jam
  echo "using python : ${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR} : ${MA_PYTHON3} ;" >> user-config-python3.jam
fi

# build

check env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam --without-python | tee -a $LOG
if [ ${MA_HAVE_PYTHON2} = "yes" ]; then
  check env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config-python2.jam --build-dir=build-python2 --stagedir=stage-python2 --with-python --with-mpi python=${MA_PYTHON2_VERSION_MAJOR}.${MA_PYTHON2_VERSION_MINOR} | tee -a $LOG
fi
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  check env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config-python3.jam --build-dir=build-python3 --stagedir=stage-python3 --with-python --with-mpi python=${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR} | tee -a $LOG
fi

# install

env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam --without-python --prefix=$PREFIX install | tee -a $LOG
cp -rp stage-python2/lib/cmake/boost_mpi_python-* stage-python2/lib/cmake/boost_numpy-* stage-python2/lib/cmake/boost_python-* $PREFIX/lib/cmake
cp -rp stage-python2/lib/boost-python* stage-python2/lib/libboost_*python* stage-python2/lib/libboost_*numpy* $PREFIX/lib
cp -rp stage-python3/lib/cmake/boost_mpi_python-* stage-python3/lib/cmake/boost_numpy-* stage-python3/lib/cmake/boost_python-* $PREFIX/lib/cmake
cp -rp stage-python3/lib/boost-python* stage-python3/lib/libboost_*python* stage-python3/lib/libboost_*numpy* $PREFIX/lib
