if [ ! -f ${HPHI_ROOT}/bin/HPhi ]; then
  echo "Error: ${HPHI_ROOT}/bin/HPhi does not exist"
  exit 127
fi

${MPIEXEC_CMD} HPhi -s stdface.def | tee std.out
