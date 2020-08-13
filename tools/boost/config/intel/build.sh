for m in mpiicpc mpicxx mpic++ mpiCC; do
  mc=$(which $m 2> /dev/null)
  test -n "$mc" && break
done
echo "using mpi : $mc ;" > user-config.jam
check env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --debug-configuration --prefix=$PREFIX --layout=system toolset=intel stage | tee -a $LOG
env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=system toolset=intel install | tee -a $LOG
