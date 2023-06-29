set -u

BJAM="./tools/build/b2 --layout=system --ignore-site-config toolset=intel"

# setup config files

for m in mpicxx mpic++ mpiicpc; do
  mc=$(which $m 2> /dev/null)
  test "$($mc --version 2> /dev/null | head -1 | cut -d ' ' -f 2)" = "oneAPI" && break
  test "$($mc --version 2> /dev/null | head -1 | cut -d ' ' -f 1)" = "icpc" && break
  mc=""
done
if [ -z "$mc" ]; then
  echo "Error: MPI C++ compiler not found"
  exit 127
fi
echo "using mpi : $mc ;" > user-config.jam
. $SCRIPT_DIR/../python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  echo "using python : ${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR} : $(${MA_PYTHON3}-config --prefix) : $(${MA_PYTHON3}-config --includes | sed 's/-I//g') ;" >> user-config.jam
fi

# build

if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam python=${MA_PYTHON3_VERSION_MAJOR}.${MA_PYTHON3_VERSION_MINOR} pch=off
else
  env BOOST_BUILD_PATH=. ${BJAM} --user-config=user-config.jam --without-python pch=off
fi
