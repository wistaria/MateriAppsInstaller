set -u

cd tools/build
sh bootstrap.sh
./b2 --prefix=$PREFIX install
