set -e

# import check (also fails if the NumPy 1.x/2.x ABI is mismatched)
python3 -c "import cryspy; print('import cryspy OK', cryspy.__version__)"

# the cryspy console script must at least start up (loads all deps, incl. the
# compiled ones). With no cryspy.in it stops early, but printing the startup
# banner proves the package and its native dependencies are functional.
cryspy > cryspy.out 2>&1 || true
grep -q "Start CrySPY" cryspy.out
echo "cryspy started OK"
