# Install TurboGenius (and its PyPI dependencies) into $PREFIX.
#
# NumPy is pinned < 2 and pandas < 2.2 in the same resolution pass. The v0.2
# release predates NumPy 2.0, so its own requirement (numpy >= 1.20.1) has no
# upper bound and pip would otherwise pull NumPy 2.x. TurboGenius also brings in
# compiled dependencies whose wheels are built against NumPy 1.x (e.g. trexio,
# pymatgen); mixing NumPy-1.x- and NumPy-2.x-built wheels makes the imports abort
# with a NumPy ABI error. These bounds keep the whole stack on the NumPy 1.x ABI.
#
# TurboGenius derives its version with setuptools_scm, which needs a .git dir or
# PyPI sdist metadata. The GitHub archive tarball has neither, so the build
# aborts with "unable to detect version". Tell setuptools_scm the version
# explicitly (keep this in sync with TURBOGENIUS_VERSION in version.sh). Recent
# setuptools_scm honours the distribution-specific variable during PEP 517
# build isolation, so set that (normalized name TURBOGENIUS) as well as the
# generic one.
export SETUPTOOLS_SCM_PRETEND_VERSION="0.2"
export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_TURBOGENIUS="0.2"
python3 -m pip install --prefix=$PREFIX "numpy<2" "pandas<2.2" ./
