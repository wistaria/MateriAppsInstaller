cd build
make ${MAKE_J} install
make install-python
if [ ! -e $PREFIX/bin/lammps ]; then
  ln -s $PREFIX/bin/lmp $PREFIX/bin/lammps
fi
cp -rp $BUILD_DIR/lammps-${__VERSION__}/examples $PREFIX/share/lammps/ || true
