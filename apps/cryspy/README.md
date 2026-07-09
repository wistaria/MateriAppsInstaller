# CrySPY

- <https://tomoki-yamashita.github.io/CrySPY_doc/>
- A crystal structure prediction tool written in Python. It searches for
  stable structures by combining structure generation (random, evolutionary
  algorithm, Bayesian optimization, LAQA, ...) with external energy
  calculators (VASP, Quantum ESPRESSO, OpenMX, soiap, ASE, ...).

## Requirements

- **Python 3.9–3.12** on `PATH` as `python3`. CrySPY pulls in
  pyxtal / pymatgen / pyshtools; pyshtools ships pre-built wheels for these
  versions. On the EOL Python 3.8 (and on very new interpreters that have no
  pyshtools wheel yet) pyshtools falls back to a source build that needs
  fftw3 / openblas development libraries and usually fails.
- Installed with `pip install` into the MateriApps prefix; dependencies are
  resolved from PyPI at install time (network required).
- `install.sh` pins `numpy < 2` and `pandas < 2.2`: some compiled
  dependencies (e.g. pyshtools) ship wheels built against NumPy 1.x, so the
  whole stack is kept on the NumPy 1.x ABI; otherwise the `cryspy` command
  aborts at import with a NumPy 1.x/2.x ABI error.

## Notes

- CrySPY itself only orchestrates the search; to run an actual structure
  prediction you also need one of the supported energy calculators (e.g.
  Quantum ESPRESSO / OpenMX from this installer) and a `cryspy.in`.
- After `sh link.sh`, `source $MA_ROOT/cryspy/cryspyvars.sh` puts the
  `cryspy` command on `PATH` and the package on `PYTHONPATH`.
- Verified on ISSP ohtaka with Python 3.9: `import cryspy` succeeds and the
  `cryspy` command starts (`Start CrySPY 1.4.3`).
