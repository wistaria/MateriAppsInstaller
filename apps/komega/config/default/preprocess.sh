set -u

FC=${FC:-mpifort}
export FC

check_file_exe=check_file_option
check_file=${check_file_exe}.f90
cat << EOF > $check_file
program check_compile_option
end
EOF

${FC} -o $check_file_exe -fallow-argument-mismatch $check_file >/dev/null 2>/dev/null
st=$?
rm -f $check_file
rm -f $check_file_exe
if [ $st -eq 0 ]; then
  ./configure --prefix=$PREFIX --with-mpi FCFLAGS="-fallow-argument-mismatch"
else
  ./configure --prefix=$PREFIX --with-mpi
fi
