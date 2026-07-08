# Unified entry point `ma.sh` — design

Issue: #182
Date: 2026-07-09

## Goal

Provide a single top-level command that installs a MateriApps application
together with the build tools it needs, instead of requiring the user to
manually `cd` into each `tools/*` and `apps/*` directory and run
`install.sh`/`link.sh` in the right order.

The existing per-directory flow is kept working unchanged; `ma.sh` only
orchestrates the existing scripts.

## Subcommands

```
sh ma.sh install <app> [mode]   # resolve deps, build missing tools, install app
sh ma.sh list                   # available apps/tools and their pinned versions
sh ma.sh installed              # what is currently installed under MA_ROOT
sh ma.sh help                   # usage
```

Non-goals (YAGNI): uninstall, upgrade/version pinning, parallel builds,
removing tools. `install` auto-builds tools only (not app→app deps).

## Dependency declaration

Each `apps/<app>/version.sh` or `tools/<tool>/version.sh` may declare its
**direct** tool dependencies with a shell variable named `<NAME>_REQUIRES`
(space-separated tool directory names), where `<NAME>` is the uppercased
package name already used in that file. Examples:

```sh
# apps/hphi/version.sh
HPHI_REQUIRES="cmake openmpi scalapack"

# tools/scalapack/version.sh
SCALAPACK_REQUIRES="openmpi lapack"
```

If the variable is absent, the package has no declared dependencies (this
is the default, so unmigrated packages behave exactly as today). The
variable name is derived as `$(toupper <name> | tr - _)_REQUIRES` to match
the existing `ROOTNAME` convention (e.g. `gcc-wrapper` → `GCC_WRAPPER_REQUIRES`).

Only **tools** may appear in a `REQUIRES` list; `ma.sh` auto-builds tools,
never apps.

## Resolution

`scripts/ma_deps.sh` provides a pure-POSIX-sh resolver, sourced by `ma.sh`
and unit-testable on its own:

- `ma_resolve <name>`: depth-first traversal of `<NAME>_REQUIRES` starting
  from the target, emitting tool directory names in dependency order
  (a dependency appears before the package that needs it). The target app
  itself is not emitted (it is installed last by `ma.sh`).
- Cycle detection: a node currently on the DFS stack that is re-entered is
  reported as an error (`Error: dependency cycle: a -> b -> a`) and aborts.
- Missing package name: a `REQUIRES` entry with no `tools/<entry>/`
  directory is an error.

`ma_resolve` reads only `version.sh` files (sourced in a subshell so their
variables do not leak), so it has no side effects and is cheap to test.

## "Is a tool already available?" check

For each tool in the resolved order, `ma.sh` decides whether to build it:

1. **Installed by the installer** — `$MA_ROOT/env.d/<tool>vars.sh` exists
   (this is exactly what `tools/<tool>/link.sh` creates). Uniform across all
   tools, needs no `find.sh`.
2. Otherwise, if `tools/<tool>/find.sh` exists and reports
   `MA_HAVE_<TOOL>=yes` (a system-provided copy), treat as available.
3. Otherwise, the tool needs to be built.

Rationale: only 15/27 tools ship a `find.sh` (openmpi and scalapack, both
common transitive deps, do not), so detection cannot rely on `find.sh`
alone. The installer-built marker in (1) works for every tool. If a system
copy exists for a tool without `find.sh`, `ma.sh` will rebuild it — safe,
just redundant.

## Build execution

```
for tool in $(ma_resolve <app>):
    if tool not available (per the check above):
        (cd tools/<tool> && sh install.sh && sh link.sh)
        . $MA_ROOT/env.sh          # so later checks/builds see it
(cd apps/<app> && sh install.sh [mode] && sh link.sh)
```

- On any failure, abort immediately with a message naming the failed
  dependency (`Error: failed to build dependency 'scalapack' of 'hphi'`).
- Idempotent/resumable: already-available tools are skipped, so re-running
  after fixing a failure continues from where it stopped. (`install.sh`
  itself still refuses to overwrite an existing prefix, so a half-built
  tool must be removed before re-running — same as today.)
- `mode` is passed only to the app's `install.sh`; tools always build with
  their default mode.

## Incremental metadata population

`ma.sh` and the resolver are generic and ship working immediately. The
`<NAME>_REQUIRES` metadata is added per package over time (same gradual
approach as #184). This PR populates `REQUIRES` only for **hphi and the
tools on its dependency chain** (cmake, openmpi, lapack, scalapack, ...),
as the worked example. Apps without `REQUIRES` fall back to installing
just that app — identical to the current manual flow.

`ma.sh list` and `ma.sh installed` do not depend on `REQUIRES` and work for
everything from day one.

## Compatibility

- No existing script is modified. `ma.sh` and `scripts/ma_deps.sh` are new;
  `version.sh` files only gain an optional variable.
- The per-directory flow (`cd apps/x && sh install.sh && sh link.sh`) is
  unchanged and remains fully supported and documented.

## Testing

- **Resolver unit tests** (`scripts/ma_deps.sh` via a test harness with a
  fixture tree of fake `version.sh` files): dependency ordering, transitive
  chains, diamond dependencies (a tool required via two paths appears once),
  cycle detection, unknown-package error.
- **Integration**: on CI, `sh ma.sh install <app>` for an app with a real
  tool dependency, asserting the tool is built before the app and the app
  ends up installed. (Chosen app kept small; heavy apps stay out of this
  test.)
- `shellcheck -s sh` over `ma.sh` and `scripts/ma_deps.sh`.
- `sh ma.sh list` / `installed` / `help` smoke checks.

## Files

- `ma.sh` (new, top level) — argument parsing + subcommand dispatch + build loop.
- `scripts/ma_deps.sh` (new) — `ma_resolve` and the availability check, sourced by `ma.sh`.
- `apps/hphi/version.sh` and the tools on its chain — add `<NAME>_REQUIRES`.
- `README.md` / `docs/sphinx/*/how_to_use` — document `ma.sh` as the quick path, keeping the per-directory flow as the detailed path.
- CI (`.github/workflows/main.yml`) — add the resolver unit test and the small integration install.
