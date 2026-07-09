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

`sh ma.sh` with no arguments, `-h`, or `--help` prints usage and exits 0.
An unknown subcommand prints usage and exits non-zero.

`install` validates its arguments before doing any work: `<app>` must be a
directory under `apps/` (otherwise error + `list` hint); `mode` is not
validated by `ma.sh` — it is passed through to the app's `install.sh`,
which already prints the available modes and exits on an unknown mode.

Non-goals (YAGNI): uninstall, upgrade/version pinning, parallel builds,
removing tools, `--force`, `--dry-run`. `install` auto-builds tools only
(not app→app deps). (`--force` and `--dry-run` are noted as possible later
enhancements but are out of scope for the first cut.)

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
never apps. Each entry is a **`tools/` directory name** (the only public
dependency identifier) — not a display name or a `find.sh` variable.

`version.sh` is treated as declarative metadata: it must contain only
variable assignments (as all current ones do). The resolver relies on this
to source it safely; a comment to that effect is added to `version.sh`
files that gain a `REQUIRES` line.

## Resolution

`scripts/ma_deps.sh` provides a pure-POSIX-sh resolver, sourced by `ma.sh`
and unit-testable on its own:

- `ma_resolve <name>`: depth-first traversal of `<NAME>_REQUIRES` starting
  from the target, emitting tool directory names in dependency order
  (a dependency appears before the package that needs it). The target app
  itself is not emitted (it is installed last by `ma.sh`). A tool reached
  via two paths (diamond) is emitted once.
- Cycle detection: a node currently on the DFS stack that is re-entered is
  reported as an error (`Error: dependency cycle: a -> b -> a`) and aborts.
- Missing package name: a `REQUIRES` entry with no `tools/<entry>/`
  directory is an error.

Implementation constraints (POSIX sh has no arrays/maps):
- `visited` and `in-progress` (DFS stack) sets are newline-delimited
  strings; membership is tested with an exact whole-line match
  (`printf '%s\n' "$set" | grep -qxF "$name"`), never a substring match.
- The traversal must accumulate output and the `visited` set in the
  current shell, not inside a command-substitution subshell (which would
  discard state). The emitted order is produced by appending each node
  after its dependencies are visited.
- Reading a package's `REQUIRES`: source only that one `version.sh` in a
  subshell and echo the single derived variable, e.g.
  `(. tools/<t>/version.sh; eval "echo \"\$$(reqvar <t>)\"")`, so nothing
  leaks into the resolver's shell. `reqvar <name>` =
  `$(echo <name> | tr 'a-z-' 'A-Z_')_REQUIRES`.

Because it only reads `version.sh` (declarative) and mutates no global
state, `ma_resolve` has no side effects and is cheap to unit-test.

## "Is a tool already available?" check

For each tool in the resolved order, `ma.sh` decides whether to build it:

1. **Installed by the installer** — `$MA_ROOT/env.d/<tool>vars.sh` exists
   **and its symlink target is readable** (a dangling link counts as *not*
   available). This is exactly what `tools/<tool>/link.sh` creates. Uniform
   across all tools, needs no `find.sh`.
2. Otherwise, if `tools/<tool>/find.sh` exists and reports
   `MA_HAVE_<TOOL>=yes` (a system-provided copy), treat as available. The
   variable name is `MA_HAVE_$(echo <tool> | tr 'a-z-' 'A-Z_')` (matching
   the existing `ROOTNAME` normalization, e.g. `gcc-wrapper` →
   `MA_HAVE_GCC_WRAPPER`). `ma.sh` sources `find.sh` in a subshell and reads
   that one variable.
3. Otherwise, the tool needs to be built.

**Environment propagation.** After building a tool (case 3), `ma.sh` sources
`$MA_ROOT/env.sh` so the installer-built tool is on `PATH`/`CMAKE_PREFIX_PATH`
for later dependency checks and builds. A tool judged available via case 2
needs **no** propagation: `find.sh` located it through the same system
search path (system `PATH`, CMake's default prefixes) that the subsequent
tool/app builds use, so it is already globally discoverable. `ma.sh`
sources `$MA_ROOT/env.sh` once at startup (erroring if it is missing —
`setup/setup.sh` must have been run first) and again after each successful
tool `link.sh`.

Rationale for the two-step check: only 15/27 tools ship a `find.sh`
(openmpi and scalapack, both common transitive deps, do not), so detection
cannot rely on `find.sh` alone. The installer-built marker in (1) works for
every tool. If a system copy exists for a tool without `find.sh`, `ma.sh`
will rebuild it — safe, just redundant.

## Build execution

```
if <app> has no <NAME>_REQUIRES:
    warn: "no dependency metadata for <app>; assuming required tools are
           already installed. Install them first if the build fails."
for tool in $(ma_resolve <app>):
    case (availability of tool):
      available            -> skip
      prefix exists but no readable env.d marker (partial/failed install)
                           -> abort with cleanup instruction (see below)
      not available        -> (cd tools/<tool> && sh install.sh && sh link.sh)
                              . $MA_ROOT/env.sh      # so later checks/builds see it
(cd apps/<app> && sh install.sh [mode] && sh link.sh)
```

- **Partial-install / resume semantics.** A tool build that fails partway
  leaves `$MA_ROOT/<tool>/<tool>-<ver>-<rev>` present with no `env.d`
  marker. On a later run `ma.sh` detects this state (prefix directory
  exists but availability check fails) and, rather than calling
  `install.sh` (which would just abort with `Error: <prefix> exists`),
  stops with a targeted instruction:
  `Error: 'scalapack' looks partially installed. Remove <prefix> and re-run.`
  So "resumable" means: **completed** tools are skipped on re-run; a tool
  left half-built is reported with the exact directory to remove. `ma.sh`
  never deletes a prefix itself (destructive actions stay manual).
- On any other failure during a tool build, abort immediately with a
  message naming the failed dependency
  (`Error: failed to build dependency 'scalapack' of 'hphi'`).
- **Unmigrated apps.** An app with no `REQUIRES` is installed directly
  (identical to the current manual flow) after the warning above, so users
  are told when dependency resolution did not run. `ma.sh list` also marks
  which apps carry dependency metadata (see Subcommands/list).
- `mode` is passed only to the app's `install.sh`; **tools always build in
  their default mode.** Limitation: if a non-default app `mode` (e.g.
  `intel`) needs its tools built with a matching toolchain, the user must
  pre-build those tools in that mode manually; auto-building mode-matched
  tool variants is out of scope for the first cut and noted in the docs.
- `ma.sh` only ever calls a package's `install.sh` and `link.sh`. It does
  not call `setup.sh`/`download.sh` directly, because each `install.sh`
  already runs its own `setup.sh` (which runs `download.sh`) internally.

## Incremental metadata population

`ma.sh` and the resolver are generic and ship working immediately. The
`<NAME>_REQUIRES` metadata is added per package over time (same gradual
approach as #184). This PR populates `REQUIRES` only for **hphi and the
tools on its dependency chain** (cmake, openmpi, lapack, scalapack, ...),
as the worked example. Apps without `REQUIRES` fall back to installing
just that app — identical to the current manual flow.

`ma.sh list` and `ma.sh installed` do not depend on `REQUIRES` and work for
everything from day one. To make the rollout visible, `ma.sh list` marks
each app that declares `REQUIRES` (e.g. a `[deps]` tag), so users can see at
a glance which apps auto-resolve their tools and which do not. Combined with
the install-time warning for apps without `REQUIRES`, this removes the
"silent no-op" concern during the migration period.

## Compatibility

- No existing script is modified. `ma.sh` and `scripts/ma_deps.sh` are new;
  `version.sh` files only gain an optional variable.
- The per-directory flow (`cd apps/x && sh install.sh && sh link.sh`) is
  unchanged and remains fully supported and documented.

## Testing

- **Resolver unit tests** (`scripts/ma_deps.sh` via a harness pointing at a
  fixture tree of fake `version.sh` files): dependency ordering, transitive
  chains, diamond dependencies (emitted once), cycle detection (error),
  unknown-package error.
- **Availability-check unit tests** (with a fake `MA_ROOT`): completed
  marker → skip; prefix-exists-without-marker → "partially installed"
  abort message; dangling `env.d` symlink → treated as unavailable;
  `find.sh` reporting `MA_HAVE_<TOOL>=yes` → skip.
- **Integration** (CI): `sh ma.sh install <app>` for an app with a real
  tool dependency, asserting (a) the tool is built before the app,
  (b) the env is reloaded so a downstream dependency sees it, and (c) the
  app ends up installed. Chosen app kept small; heavy apps stay out.
- **CLI smoke**: no-args/`-h`/`--help`/unknown-subcommand usage, and
  `list` (incl. the `[deps]` marker) / `installed`.
- `shellcheck -s sh` over `ma.sh` and `scripts/ma_deps.sh`.

## Resolved questions (from design review)

- **App/mode validation**: `ma.sh` checks `apps/<app>/` exists; `mode` is
  passed through to the app's `install.sh`, which already validates it and
  lists available modes on error. (Codex Q1)
- **Dependency identifiers**: `REQUIRES` entries are `tools/` directory
  names only — the single public identifier. (Codex Q2)
- **System tools and env**: a tool found via `find.sh` needs no environment
  fragment; it is already on the system search path that later builds use.
  Only installer-built tools require `. $MA_ROOT/env.sh`. (Codex Q3)
- **setup.sh**: `ma.sh` calls only `install.sh`+`link.sh`; each
  `install.sh` runs its own `setup.sh`/`download.sh` internally. (Codex Q4)
- **Tool build mode**: tools build in default mode; mode-matched tool
  variants for non-default app modes are a documented limitation, not
  auto-handled. (Antigravity Q1)
- **Docs structure**: README presents `ma.sh install` as the quick path but
  states plainly that automatic dependency resolution applies only to apps
  with declared metadata; the per-directory flow is documented as the
  complete/fallback path. `list` marks apps that carry metadata. (Antigravity Q2)

## Deferred (possible later enhancements, out of scope)

`--force` (rebuild deps), `--dry-run` (print resolved order without
building), and merging `installed` into `list --installed`. Recorded so the
CLI can grow into them without redesign; not built now (YAGNI).

## Files

- `ma.sh` (new, top level) — argument parsing + subcommand dispatch + build loop.
- `scripts/ma_deps.sh` (new) — `ma_resolve` and the availability check, sourced by `ma.sh`.
- `apps/hphi/version.sh` and the tools on its chain — add `<NAME>_REQUIRES`.
- `README.md` / `docs/sphinx/*/how_to_use` — document `ma.sh` as the quick path, keeping the per-directory flow as the detailed path.
- CI (`.github/workflows/main.yml`) — add the resolver unit test and the small integration install.
