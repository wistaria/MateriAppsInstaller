# Install CrySPY (and its PyPI dependencies) into $PREFIX.
#
# NumPy is pinned < 2 and pandas < 2.2 in the same resolution pass. CrySPY
# pulls in compiled dependencies whose wheels are built against NumPy 1.x
# (e.g. pyshtools); resolving without these bounds mixes NumPy-1.x- and
# NumPy-2.x-built wheels and the `cryspy` command then aborts at import with
# a NumPy ABI error ("Cannot convert numpy.ndarray to numpy.ndarray"). The
# bounds keep every compiled dependency on the NumPy 1.x ABI.
python3 -m pip install --prefix=$PREFIX "numpy<2" "pandas<2.2" ./
