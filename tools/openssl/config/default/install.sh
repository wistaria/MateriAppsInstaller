set -u

make ${MAKE_J} install
cp -rp $SCRIPT_DIR/cert/cacert.pem $PREFIX/ssl/cert.pem
