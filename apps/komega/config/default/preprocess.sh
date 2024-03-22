set -u

FC=${FC:-mpifort}
export FC

check_file=check_compile_option.f90
cat << EOF > $check_file
program check_compile_option
end
EOF

${FC} -fallow-argument-mismatch $check_file >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
  ./configure --prefix=$PREFIX --with-mpi FCFLAGS="-fallow-argument-mismatch"
else
  ./configure --prefix=$PREFIX --with-mpi
fi
