# TurboRVB

- <https://github.com/sissaschool/turborvb>
- <https://sissaschool.github.io/turborvb_website/>
- An ab initio quantum Monte Carlo (QMC) package for molecular and bulk
  electronic systems, based on resonating valence bond (RVB) wavefunctions.
  It performs variational (VMC) and lattice-regularized diffusion (LRDMC)
  Monte Carlo calculations.

## Requirements

- **CMake 3.20+**, a **Fortran and C compiler** (GNU, Intel oneAPI, or NVHPC),
  and **BLAS / LAPACK** (Intel MKL is detected and used automatically when
  available).
- **MPI** (Fortran + C) for the parallel build. The default build compiles both
  the serial and the parallel (MPI) versions; if no MPI compiler is found CMake
  automatically drops the parallel targets, so the full build documented here
  requires an MPI installation. ScaLAPACK is linked when found (MKL ScaLAPACK,
  or a system ScaLAPACK).

## Build

`install.sh` runs an out-of-source CMake build with the default options
(`EXT_SERIAL=ON`, `EXT_PARALLEL=ON`, QMC + DFT + tools). Set `CC` / `FC` in
`~/.mainstaller` or the environment to select a specific compiler (CMake honours
the `CC` / `FC` variables); `MA_EXTRA_FLAGS` is passed as extra C/Fortran flags
and `MAKE_J` controls the parallel make.

Installed executables (`$TURBORVB_ROOT/bin`) include the QMC engine
(`turborvb-serial.x`, `turborvb-mpi.x`), the DFT prep step (`prep-serial.x`,
`prep-mpi.x`), and the tools (`makefort10.x`, `readalles.x`,
`convertfort10-serial.x`, `readforward-serial.x`, ...).

## Notes

- After `sh link.sh`, `source $MA_ROOT/turborvb/turborvbvars.sh` puts the
  TurboRVB binaries on `PATH` and exports `TURBORVB_ROOT`.
- **TurboGenius integration:** the [turbogenius](../turbogenius) Python wrapper
  reads `TURBORVB_ROOT` at import time. Source `turborvbvars.sh` before
  `turbogeniusvars.sh` so TurboGenius drives this TurboRVB build. TurboRVB
  v1.0.0 names some serial tools with a `-serial` suffix
  (`convertfort10-serial.x`, `convertfort10mol-serial.x`); if a TurboGenius
  workflow expects the unsuffixed names, set the corresponding
  `TURBO*_RUN_COMMAND` environment variables (see `pyturbo/utils/env.py`).
- License: GNU GPL v3.
