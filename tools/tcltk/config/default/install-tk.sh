set -u

cd tk/unix
make ${MAKE_J} install
. ${PREFIX}/lib/tkConfig.sh
ln -s wish${TK_VERSION} ${PREFIX}/bin/wish
