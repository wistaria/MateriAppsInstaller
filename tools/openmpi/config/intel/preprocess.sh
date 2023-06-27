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

if [ $(which icx 2> /dev/null) ]; then
  ./configure --prefix=$PREFIX --with-hwloc $SLURM_OPT CC=icx CXX=icpx FC=ifx
else
  ./configure --prefix=$PREFIX --with-hwloc $SLURM_OPT CC=icc CXX=icpc FC=ifort
fi
