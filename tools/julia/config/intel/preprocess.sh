set -u

echo "prefix = ${PREFIX}" > Make.user
echo "USE_INTEL_MKL = 1" >> Make.user
# echo "USE_INTEL_LIBM = 1" >> Make.user
# echo "USE_INTEL_JITEVENTS = 1" >> Make.user
# echo "USEICC = 1" >> Make.user
# echo "USEIFC = 1" >> Make.user
