cat << EOF > $MA_ROOT/env.sh
export MA_ROOT=$MA_ROOT
export PATH=\$MA_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$MA_ROOT/lib:\$LD_LIBRARY_PATH
unset i
for i in \$(find \$MA_ROOT/env.d -name '*.sh' | sort); do
  if [ -r "\$i" ]; then
    if [ "\${-#*i}" != "\$-" ]; then
      . "\$i"
    else
      . "\$i" >/dev/null 2>&1
    fi
  fi
done
unset i
EOF

# workaround for debian/ubuntu libscalapack-openmpi-dev package
mkdir -p $MA_ROOT/lib/cmake
SCALAPACK_CMAKE=$(ls /usr/lib/cmake/scalapack-*.openmpi/scalapack*.cmake 2> /dev/null)
if [ -z "${SCALAPACK_CMAKE}" ]; then :; else
  for f in ${SCALAPACK_CMAKE}; do
    sed -e 's%${_IMPORT_PREFIX}/lib%/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}%g' ${f} > $MA_ROOT/lib/cmake/$(basename ${f})
  done
  echo "export scalapack_DIR=\$MA_ROOT/lib/cmake" >> $MA_ROOT/env.sh
  echo "export SCALAPACK_DIR=\$scalapack_DIR" >> $MA_ROOT/env.sh
fi
