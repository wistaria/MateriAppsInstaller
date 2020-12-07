BJAM="$PREFIX/bin/b2 --layout=system --ignore-site-config"

env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam --without-python --prefix=$PREFIX install
. $SCRIPT_DIR/../python2/find.sh
if [ ${MA_HAVE_PYTHON2} = "yes" ]; then
  cp -rp stage-python2/lib/cmake/boost_mpi_python-* stage-python2/lib/cmake/boost_numpy-* stage-python2/lib/cmake/boost_python-* $PREFIX/lib/cmake
  cp -rp stage-python2/lib/libboost_*python* stage-python2/lib/libboost_*numpy* $PREFIX/lib
  mkdir -p $PREFIX/lib/python${MA_PYTHON2_VERSION_MAJOR}.${MA_PYTHON2_VERSION_MINOR}/boost
  cp -rp stage-python2/lib/boost-python${MA_PYTHON2_VERSION_MAJOR}.${MA_PYTHON2_VERSION_MINOR}/mpi.so $PREFIX/lib/python${MA_PYTHON2_VERSION_MAJOR}.${MA_PYTHON2_VERSION_MINOR}/boost
fi
. $SCRIPT_DIR/../python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  cp -rp stage-python3/lib/cmake/boost_mpi_python-* stage-python3/lib/cmake/boost_numpy-* stage-python3/lib/cmake/boost_python-* $PREFIX/lib/cmake
  cp -rp stage-python3/lib/libboost_*python* stage-python3/lib/libboost_*numpy* $PREFIX/lib
  mkdir -p $PREFIX/lib/python${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR}/boost 2>&1
  cp -rp stage-python3/lib/boost-python${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR}/mpi.so $PREFIX/lib/python${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR}/boost
  ln -sf python${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR} $PREFIX/lib/python
fi
