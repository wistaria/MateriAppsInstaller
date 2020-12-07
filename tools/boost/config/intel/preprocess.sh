set -u

cd tools/build
sh bootstrap.sh -with-toolset=intel-linux
./b2 --prefix=$PREFIX install
