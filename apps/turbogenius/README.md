# TurboGenius

- <https://github.com/kousuke-nakano/turbogenius>
- Python wrappers for the ab initio quantum Monte Carlo package TurboRVB.
  TurboGenius drives TurboRVB jobs from Python and enables high-throughput
  QMC workflows (VMC, LRDMC, structure optimization, ...).

## Requirements

- **Python 3.8.11+** on `PATH` as `python3` (3.9–3.12 recommended). TurboGenius
  pulls in compiled dependencies (trexio, pymatgen) that ship pre-built wheels;
  make sure the interpreter has a matching wheel or the build falls back to a
  source build that needs extra system libraries (HDF5 for trexio) and usually
  fails.
- Installed with `pip install` into the MateriApps prefix; dependencies are
  resolved from PyPI at install time (network required).
- `install.sh` pins `numpy < 2` and `pandas < 2.2`: the v0.2 release predates
  NumPy 2.0, so its own `numpy >= 1.20.1` requirement has no upper bound and pip
  would otherwise pull NumPy 2.x; some compiled dependencies (e.g. trexio,
  pymatgen) ship wheels built against NumPy 1.x, so the whole stack is kept on
  the NumPy 1.x ABI. Otherwise `import turbogenius` aborts with a NumPy ABI
  error.

## Notes

- TurboGenius is only the Python driver layer. To run actual QMC calculations
  you also need the TurboRVB binaries (`turborvb.x`, `prep.x`, ...), which are
  built separately from <https://github.com/sissaschool/turborvb>.
- `pyturbo` reads `TURBORVB_ROOT` **at import time**, so it must be set even to
  `import turbogenius`. The generated `turbogeniusvars.sh` resolves it in order:
  (1) an already-set `TURBORVB_ROOT`; (2) if the MateriApps `turborvb` package
  is installed, it sources that package's `turborvbvars.sh` automatically, which
  sets the versioned `TURBORVB_ROOT` that actually contains the binaries; (3)
  otherwise it falls back to the bare `$MA_ROOT/turborvb`, which only makes the
  Python layer importable. So installing the `turborvb` package first is enough
  — you do not have to remember to source `turborvbvars.sh` before
  `turbogeniusvars.sh`. For a TurboRVB build outside MateriApps, export
  `TURBORVB_ROOT` yourself before running real calculations.
- After `sh link.sh`, `source $MA_ROOT/turbogenius/turbogeniusvars.sh` puts the
  `turbogenius` command on `PATH`, the package on `PYTHONPATH`, and sets
  `TURBORVB_ROOT`.
- Verified on ISSP ohtaka: install succeeds with `numpy 1.26.4` / `pandas
  2.1.4`, `import turbogenius` works, and the `turbogenius` console script
  prints its usage.
