for exe in tenes_simple tenes_std tenes; do
  if [ ! -x ${PREFIX}/bin/$exe ]; then
    echo "Error: ${PREFIX}/bin/${exe} does not exist"
    exit 127
  fi
done

tenes_simple simple.toml
tenes_std std.toml
${MPIEXEC_CMD} tenes input.toml 2>&1 | tee log
