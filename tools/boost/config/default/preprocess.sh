set -u

sh bootstrap.sh
./b2 --prefix=$PREFIX install
