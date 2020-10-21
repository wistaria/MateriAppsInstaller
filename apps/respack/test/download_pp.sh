sdir=$(dirname $(readlink -f $0))
parent_dir=$(readlink -f ${sdir}/../)
ppfile=Si.pbe-n-kjpaw_psl.1.0.0.UPF
pppath=${sdir}/${ppfile}
if [ ! -f $pppath ] ; then
  echo "Start downloading pseudo potential file"
  wget https://www.quantum-espresso.org/upf_files/${ppfile} -O $pppath
  if [ $? != 0 ]; then
    echo "Failed to download the pseudo potential file"
    echo "Download ${ppfile} manually from QE official site"
    echo "and put it to ${parent_dir}/test"
    exit 127
  fi
  cp $pppath ${parent_dir}/test
fi
