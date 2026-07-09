set -e

# import check (also fails if the NumPy 1.x/2.x ABI is mismatched)
python3 -c "import cryspy; print('import cryspy OK', cryspy.__version__)"

# The cryspy console script must at least start up: importing it here loads all
# dependencies (including the compiled ones), and printing the startup banner
# proves the package and its native deps are functional. With no cryspy.in in
# the working directory it stops early with a nonzero exit, which is expected
# and tolerated below. A timeout (when available) guards against a future
# behavior change that would block waiting for input instead of stopping.
if command -v timeout >/dev/null 2>&1; then
  RUN_CRYSPY="timeout 120 cryspy"
else
  RUN_CRYSPY="cryspy"
fi
$RUN_CRYSPY > cryspy.out 2>&1 && status=0 || status=$?

# A 124 exit from timeout means cryspy hung: fail loudly instead of masking it.
if [ "$status" = "124" ]; then
  echo "Error: cryspy did not terminate within the timeout" >&2
  cat cryspy.out
  exit 1
fi

# The startup banner must be present regardless of the early no-input exit.
grep -q "Start CrySPY" cryspy.out
echo "cryspy started OK"
