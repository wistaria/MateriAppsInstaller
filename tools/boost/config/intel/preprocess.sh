set -u

cd tools/build
sh bootstrap.sh intel-linux
./b2 --prefix=$PREFIX install
