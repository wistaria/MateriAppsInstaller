set -e

# import check (also fails if the NumPy 1.x/2.x ABI is mismatched, since the
# import pulls in the compiled dependencies trexio / pymatgen)
python3 -c "import turbogenius; print('import turbogenius OK')"

# The turbogenius console script (a click CLI) must at least print its help,
# which loads the CLI module and all of its dependencies. A timeout (when
# available) guards against a future change that would block waiting for input.
if command -v timeout >/dev/null 2>&1; then
  RUN_TG="timeout 120 turbogenius"
else
  RUN_TG="turbogenius"
fi
$RUN_TG --help > turbogenius.out 2>&1 && status=0 || status=$?

# A 124 exit from timeout means the CLI hung: fail loudly instead of masking it.
if [ "$status" = "124" ]; then
  echo "Error: turbogenius --help did not terminate within the timeout" >&2
  cat turbogenius.out
  exit 1
fi

# --help must succeed and print a click usage banner.
if [ "$status" != "0" ]; then
  echo "Error: turbogenius --help exited with status $status" >&2
  cat turbogenius.out
  exit 1
fi
grep -qi "Usage" turbogenius.out
echo "turbogenius CLI OK"
