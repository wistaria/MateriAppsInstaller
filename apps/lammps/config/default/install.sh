cd build
make ${MAKE_J} install
cp -rp $BUILD_DIR/lammps-${__VERSION__}/examples $PREFIX/share/lammps/ || true
