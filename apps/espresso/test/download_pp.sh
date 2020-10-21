sdir=$(dirname $(readlink -f $0))
ppfile=Si.pbe-n-kjpaw_psl.1.0.0.UPF
pppath=${sdir}/${ppfile}
if [ ! -f $pppath ] ; then
  echo "Start downloading pseudo potential file"
  wget https://www.quantum-espresso.org/upf_files/Si.pbe-n-kjpaw_psl.1.0.0.UPF -O $pppath
  if [ $? != 0 ]; then
    echo "Failed to download the pseudo potential file"
    echo "Download ${ppfile} manually from QE official site"
    echo "and put it to $sdir"
    exit 127
  fi
fi
