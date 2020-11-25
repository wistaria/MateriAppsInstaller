set -u

# find slurm
if [ $(which sinfo 2> /dev/null) ]; then
  SLURM_OPT="--with-slurm --with-pmi=$(dirname $(dirname $(which sinfo)))"
fi

./configure --prefix=$PREFIX --with-hwloc $SLURM_OPT
