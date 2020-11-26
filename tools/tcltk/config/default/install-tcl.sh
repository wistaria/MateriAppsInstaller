set -u

cd tcl/unix
make ${MAKE_J} install
. ${PREFIX}/lib/tclConfig.sh
ln -s tclsh${TCL_VERSION} ${PREFIX}/bin/tclsh
