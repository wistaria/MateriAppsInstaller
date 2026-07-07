# scripts/ — shared and maintenance scripts

## Sourced by package scripts

- `util.sh` — shared shell library (`set_prefix`, `check`, `pipefail`,
  `find_tool`, ...). Sourced by every install/download/setup script.
- `cmake-find-package.sh` — prints the version of a package found via
  CMake `find_package`; used by `tools/*/find.sh`.
- `cmake-find-package-test.sh` — debug variant that prints the raw
  CMake find-debug output.

## Maintenance tools (run manually or from CI)

- `list_maversion.sh` — list the pinned versions of all tools and apps.
- `check_upstream_versions.sh [--create-issues]` — compare the pins of
  GitHub-hosted packages with the latest upstream releases; used by the
  `version watch` workflow to file update issues (at most
  `MAX_ISSUES` (default 10) new issues per run).
- `check_mpicompiler.sh CC MPICC` — verify a compiler and its MPI
  wrapper report the same version.
- `fix_dylib.sh DIR` — rewrite install names of the shared libraries
  under DIR (macOS).
