set -u

# find slurm
SLURM_OPT=""
if [ $(which sinfo 2> /dev/null) ]; then
  if [ -f /usr/include/slurm/pmi2.h ]; then
    SLURM_OPT="--with-slurm --with-pmi"
  else
    SLURM_OPT="--with-slurm --with-pmi=$(dirname $(dirname $(which sinfo)))"
  fi
fi

./configure --prefix=$PREFIX --with-hwloc $SLURM_OPT CC=gcc CXX=g++ FC=gfortran
