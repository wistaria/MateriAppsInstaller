# Unified entry point `ma.sh` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a top-level `ma.sh` that installs a MateriApps app together with the build tools it needs, by resolving each app's tool dependencies transitively and driving the existing per-package `install.sh`/`link.sh`.

**Architecture:** A pure-POSIX-sh dependency resolver (`scripts/ma_deps.sh`, sourceable and unit-testable) plus a thin CLI/orchestrator (`ma.sh`). Dependencies are declared as an optional `<NAME>_REQUIRES` variable in each package's `version.sh`. Tool availability is decided from the installer's own `env.d/<tool>vars.sh` marker first, then a secondary `find.sh` system check. No existing script is modified; `version.sh` files only gain an optional variable.

**Tech Stack:** POSIX `sh` (the repo targets `sh`, not bash), the existing `scripts/util.sh` helpers, GitHub Actions, shellcheck.

## Global Constraints

- POSIX `sh` only — no bashisms (no arrays, `[[ ]]`, etc.). `local` is allowed (used throughout `scripts/util.sh`; `.shellcheckrc` disables SC3043).
- Never modify existing `install.sh`/`link.sh`/`setup.sh`/`util.sh` behavior; `ma.sh` orchestrates them by calling `sh install.sh` / `sh link.sh`.
- `ma.sh` and `scripts/ma_deps.sh` must pass `shellcheck --severity=warning -s sh`.
- The repo root (directory containing `apps/`, `tools/`, `scripts/`) is referred to as `$MA_TOP`. It is distinct from `$MA_ROOT` (the install prefix from `set_prefix`).
- Tool/app directory names are the only public dependency identifiers; they are whitespace-free.
- Variable-name normalization (used for both `<NAME>_REQUIRES` and `MA_HAVE_<TOOL>`): uppercase, then map every non-`[A-Z0-9]` character to `_`.
- Commit after every task (each task ends green).

---

## File Structure

- `scripts/ma_deps.sh` (new) — resolver + availability functions, sourced by `ma.sh` and by the test script. Sourcing it defines functions only (no side effects). Functions read `$MA_TOP` for the repo tree and `$MA_ROOT` for install state.
- `ma.sh` (new, repo root) — argument parsing, subcommand dispatch (`install`/`list`/`installed`/`help`), and the install build loop.
- `scripts/ma_deps_test.sh` (new) — shell unit tests for the resolver and the availability check, using fixture trees under a temp dir. Runnable as `sh scripts/ma_deps_test.sh`.
- `scripts/ma_integration_test.sh` (new) — fixture-based integration test that runs the real `ma.sh install` against fake tool/app packages (trivial `install.sh`/`link.sh`) to verify build order, env reload, marker-skip, and partial-install abort — without heavy real builds.
- `apps/hphi/version.sh` + `tools/scalapack/version.sh` (modified) — add `<NAME>_REQUIRES` as the worked example (`cmake`, `openmpi`, `lapack` declare none).
- `.github/workflows/main.yml` (modified) — new `ma` job running shellcheck + the two test scripts + the `version.sh` lint.
- `README.md`, `docs/sphinx/en/source/how_to_use/index.rst`, `docs/sphinx/ja/source/how_to_use/index.rst` (modified) — document `ma.sh` as the quick path.

---

### Task 1: `ma_reqvar` and `ma_requires` (read a package's declared deps)

**Files:**
- Create: `scripts/ma_deps.sh`
- Test: `scripts/ma_deps_test.sh`

**Interfaces:**
- Produces:
  - `ma_reqvar <name>` → prints the normalized requires-variable name, e.g. `hphi`→`HPHI_REQUIRES`, `gcc-wrapper`→`GCC_WRAPPER_REQUIRES`.
  - `ma_requires <kind> <name>` (`kind` = `apps` or `tools`) → prints the space-separated direct dependency list from `$MA_TOP/<kind>/<name>/version.sh` (empty if the file or the variable is absent). Sources that one `version.sh` in a subshell so nothing leaks.

- [ ] **Step 1: Write the failing test**

Create `scripts/ma_deps_test.sh`:

```sh
#!/bin/sh
# Unit tests for scripts/ma_deps.sh. Run: sh scripts/ma_deps_test.sh
set -u

THIS_DIR=$(cd "$(dirname "$0")" && pwd)
. "$THIS_DIR/ma_deps.sh"

FAILED=0
fail() { echo "FAIL: $1"; FAILED=1; }
assert_eq() { # <got> <want> <msg>
  if [ "$1" != "$2" ]; then fail "$3: expected [$2] got [$1]"; fi
}

# --- fixture repo tree ---
FIX=$(mktemp -d)
trap 'rm -rf "$FIX"' EXIT
mkdir -p "$FIX/apps/app1" "$FIX/tools/t1" "$FIX/tools/t2"
cat > "$FIX/apps/app1/version.sh" <<'EOF'
APP1_VERSION="1.0"
__NAME__=app1
APP1_REQUIRES="t1 t2"
EOF
cat > "$FIX/tools/t1/version.sh" <<'EOF'
T1_VERSION="1.0"
__NAME__=t1
EOF
# t2 has no version.sh REQUIRES var at all
cat > "$FIX/tools/t2/version.sh" <<'EOF'
T2_VERSION="1.0"
__NAME__=t2
EOF
MA_TOP="$FIX"

# --- ma_reqvar ---
assert_eq "$(ma_reqvar hphi)" "HPHI_REQUIRES" "reqvar simple"
assert_eq "$(ma_reqvar gcc-wrapper)" "GCC_WRAPPER_REQUIRES" "reqvar dash"
assert_eq "$(ma_reqvar gcc10)" "GCC10_REQUIRES" "reqvar digits"

# --- ma_requires ---
assert_eq "$(ma_requires apps app1)" "t1 t2" "requires app1"
assert_eq "$(ma_requires tools t1)" "" "requires t1 empty"
assert_eq "$(ma_requires tools nope)" "" "requires missing dir empty"

[ "$FAILED" -eq 0 ] && echo "ALL TESTS PASSED"
exit "$FAILED"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_deps_test.sh`
Expected: FAIL — `.../ma_deps.sh` does not exist yet (source error), or `ma_reqvar: not found`.

- [ ] **Step 3: Write minimal implementation**

Create `scripts/ma_deps.sh`:

```sh
#!/bin/sh
# Dependency resolution and tool-availability helpers for ma.sh.
# Sourcing this file only defines functions (no side effects).
#
# Callers must set:
#   MA_TOP   - repo root (contains apps/, tools/, scripts/)
#   MA_ROOT  - install prefix (for the availability functions; set by set_prefix)

# ma_reqvar <name> -> normalized "<NAME>_REQUIRES" (valid shell identifier)
ma_reqvar() {
  _var=$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | tr -c 'A-Z0-9' '_')
  printf '%s_REQUIRES' "$_var"
}

# ma_requires <kind> <name>  (kind = apps|tools) -> space-separated direct deps
ma_requires() {
  _vf="$MA_TOP/$1/$2/version.sh"
  [ -f "$_vf" ] || return 0
  _rv=$(ma_reqvar "$2")
  ( . "$_vf" >/dev/null 2>&1; eval "printf '%s' \"\${$_rv:-}\"" )
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `sh scripts/ma_deps_test.sh`
Expected: `ALL TESTS PASSED`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/ma_deps.sh scripts/ma_deps_test.sh
git commit -m "feat(ma): add ma_reqvar and ma_requires dependency readers"
```

---

### Task 2: `ma_resolve` (transitive topological order + cycle/unknown detection)

**Files:**
- Modify: `scripts/ma_deps.sh`
- Test: `scripts/ma_deps_test.sh`

**Interfaces:**
- Consumes: `ma_requires`, `ma_reqvar` (Task 1).
- Produces: `ma_resolve <app>` → prints the transitive tool dependencies of `apps/<app>` in dependency order (each on its own line; a dependency before its dependents; diamonds emitted once; the app itself not emitted). Exit 1 on a dependency cycle or an unknown tool (message to stderr).

- [ ] **Step 1: Write the failing test**

Append to `scripts/ma_deps_test.sh`, before the final `[ "$FAILED" ... ]` line:

```sh
# --- ma_resolve: diamond + transitive ---
# app hphix -> cmake, openmpix, scalapackx ; scalapackx -> openmpix, lapackx
mkdir -p "$FIX/apps/hphix" "$FIX/tools/cmakex" "$FIX/tools/openmpix" \
         "$FIX/tools/lapackx" "$FIX/tools/scalapackx"
printf 'HPHIX_REQUIRES="cmakex openmpix scalapackx"\n'  > "$FIX/apps/hphix/version.sh"
printf 'SCALAPACKX_REQUIRES="openmpix lapackx"\n'       > "$FIX/tools/scalapackx/version.sh"
: > "$FIX/tools/cmakex/version.sh"
: > "$FIX/tools/openmpix/version.sh"
: > "$FIX/tools/lapackx/version.sh"

order=$(ma_resolve hphix) || fail "resolve hphix exited nonzero"
# openmpix must appear exactly once, before scalapackx; lapackx before scalapackx
assert_eq "$(printf '%s\n' "$order" | grep -c '^openmpix$')" "1" "openmpix once (diamond)"
pos_omp=$(printf '%s\n' "$order" | grep -n '^openmpix$'   | cut -d: -f1)
pos_lap=$(printf '%s\n' "$order" | grep -n '^lapackx$'    | cut -d: -f1)
pos_sca=$(printf '%s\n' "$order" | grep -n '^scalapackx$' | cut -d: -f1)
[ "$pos_omp" -lt "$pos_sca" ] || fail "openmpix must precede scalapackx"
[ "$pos_lap" -lt "$pos_sca" ] || fail "lapackx must precede scalapackx"

# --- ma_resolve: cycle detection ---
mkdir -p "$FIX/apps/cyc" "$FIX/tools/a" "$FIX/tools/b"
printf 'CYC_REQUIRES="a"\n' > "$FIX/apps/cyc/version.sh"
printf 'A_REQUIRES="b"\n'   > "$FIX/tools/a/version.sh"
printf 'B_REQUIRES="a"\n'   > "$FIX/tools/b/version.sh"
if ma_resolve cyc >/dev/null 2>&1; then fail "cycle should exit nonzero"; fi

# --- ma_resolve: unknown tool ---
mkdir -p "$FIX/apps/badref"
printf 'BADREF_REQUIRES="ghost"\n' > "$FIX/apps/badref/version.sh"
if ma_resolve badref >/dev/null 2>&1; then fail "unknown tool should exit nonzero"; fi

# --- ma_resolve: app with no deps -> empty output, exit 0 ---
mkdir -p "$FIX/apps/nodeps"; : > "$FIX/apps/nodeps/version.sh"
order=$(ma_resolve nodeps) || fail "nodeps should exit 0"
assert_eq "$order" "" "nodeps empty order"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_deps_test.sh`
Expected: FAIL — `ma_resolve: not found`.

- [ ] **Step 3: Write minimal implementation**

Append to `scripts/ma_deps.sh`:

```sh
# Exact whole-line membership test (never substring).
ma__member() { printf '%s\n' "$2" | grep -qxF "$1"; }

# DFS over tool deps. Uses caller-scoped _visited/_stack/_out (dynamic scope).
ma__visit_tool() {
  local _t="$1" _d
  ma__member "$_t" "$_visited" && return 0
  if ma__member "$_t" "$_stack"; then
    echo "Error: dependency cycle involving '$_t'" >&2
    return 1
  fi
  if [ ! -d "$MA_TOP/tools/$_t" ]; then
    echo "Error: unknown tool '$_t' in a REQUIRES list" >&2
    return 1
  fi
  _stack="$_stack
$_t"
  for _d in $(ma_requires tools "$_t"); do
    ma__visit_tool "$_d" || return 1
  done
  _stack=$(printf '%s\n' "$_stack" | grep -vxF "$_t")
  _visited="$_visited
$_t"
  _out="$_out$_t
"
}

# ma_resolve <app> -> transitive tool deps, dependency order, one per line.
ma_resolve() {
  local _app="$1" _d
  local _visited="" _stack="" _out=""
  for _d in $(ma_requires apps "$_app"); do
    ma__visit_tool "$_d" || return 1
  done
  printf '%s' "$_out"
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `sh scripts/ma_deps_test.sh`
Expected: `ALL TESTS PASSED`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/ma_deps.sh scripts/ma_deps_test.sh
git commit -m "feat(ma): add ma_resolve transitive resolver with cycle/unknown detection"
```

---

### Task 3: `ma_tool_status` (availability: available / partial / absent)

**Files:**
- Modify: `scripts/ma_deps.sh`
- Test: `scripts/ma_deps_test.sh`

**Interfaces:**
- Consumes: `ma_reqvar` (for `MA_HAVE_<TOOL>` name) and `$MA_TOP`, `$MA_ROOT`.
- Produces: `ma_tool_status <tool>` → prints one of `available`, `partial`, `absent` (always exit 0). Precedence: installer marker (`$MA_ROOT/env.d/<tool>vars.sh`, readable) → `available`; else installer prefix dir present but no readable marker → `partial`; else `find.sh` reports `MA_HAVE_<TOOL>=yes` → `available`; else `absent`.

- [ ] **Step 1: Write the failing test**

Append to `scripts/ma_deps_test.sh`:

```sh
# --- ma_tool_status ---
MA_ROOT="$FIX/maroot"
mkdir -p "$MA_ROOT/env.d"
# tool st1 with a version.sh (needed for prefix path)
mkdir -p "$FIX/tools/st1"; printf '__VERSION__=1.0\n__MA_REVISION__=1\n' > "$FIX/tools/st1/version.sh"

# absent: nothing installed, no find.sh
assert_eq "$(ma_tool_status st1)" "absent" "status absent"

# partial: prefix dir exists, no marker
mkdir -p "$MA_ROOT/st1/st1-1.0-1"
assert_eq "$(ma_tool_status st1)" "partial" "status partial"

# available: readable marker present
target="$MA_ROOT/st1/st1vars-1.0-1.sh"; : > "$target"
ln -s "$target" "$MA_ROOT/env.d/st1vars.sh"
assert_eq "$(ma_tool_status st1)" "available" "status available (marker)"

# dangling marker -> not available (falls back to partial, prefix still there)
rm -f "$target"
assert_eq "$(ma_tool_status st1)" "partial" "status dangling marker -> partial"

# find.sh available for a tool with no installer state
mkdir -p "$FIX/tools/st2"; printf '__VERSION__=1.0\n__MA_REVISION__=1\n' > "$FIX/tools/st2/version.sh"
printf 'MA_HAVE_ST2=yes\n' > "$FIX/tools/st2/find.sh"
assert_eq "$(ma_tool_status st2)" "available" "status find.sh yes"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_deps_test.sh`
Expected: FAIL — `ma_tool_status: not found`.

- [ ] **Step 3: Write minimal implementation**

Append to `scripts/ma_deps.sh`:

```sh
# ma__tool_prefix_exists <tool> -> 0 if $MA_ROOT/<t>/<t>-<ver>-<rev> exists
ma__tool_prefix_exists() {
  local _t="$1"
  ( . "$MA_TOP/tools/$_t/version.sh" >/dev/null 2>&1
    [ -n "${__VERSION__:-}" ] || exit 1
    [ -d "$MA_ROOT/$_t/$_t-${__VERSION__}-${__MA_REVISION__}" ] )
}

# ma__find_have <tool> -> value of MA_HAVE_<TOOL> from tools/<t>/find.sh (or empty)
ma__find_have() {
  local _t="$1" _hv
  _hv="MA_HAVE_$(printf '%s' "$_t" | tr '[:lower:]' '[:upper:]' | tr -c 'A-Z0-9' '_')"
  # find.sh derives paths from SCRIPT_DIR; set it so it resolves correctly.
  ( SCRIPT_DIR="$MA_TOP/tools/$_t"
    . "$MA_TOP/tools/$_t/find.sh" >/dev/null 2>&1
    eval "printf '%s' \"\${$_hv:-}\"" )
}

# ma_tool_status <tool> -> available | partial | absent
ma_tool_status() {
  local _t="$1" _marker="$MA_ROOT/env.d/${1}vars.sh"
  if [ -f "$_marker" ] && [ -r "$_marker" ]; then
    echo available; return 0
  fi
  if ma__tool_prefix_exists "$_t"; then
    echo partial; return 0
  fi
  if [ -f "$MA_TOP/tools/$_t/find.sh" ] && [ "$(ma__find_have "$_t")" = "yes" ]; then
    echo available; return 0
  fi
  echo absent
}
```

Note: `[ -f "$_marker" ]` follows symlinks, so a dangling symlink is not `-f` → not available (correct).

- [ ] **Step 4: Run test to verify it passes**

Run: `sh scripts/ma_deps_test.sh`
Expected: `ALL TESTS PASSED`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/ma_deps.sh scripts/ma_deps_test.sh
git commit -m "feat(ma): add ma_tool_status availability check"
```

---

### Task 4: `ma.sh` CLI skeleton (dispatch, usage, install arg validation)

**Files:**
- Create: `ma.sh`
- Test: `scripts/ma_integration_test.sh`

**Interfaces:**
- Consumes: `scripts/ma_deps.sh`, `scripts/util.sh` (`set_prefix`).
- Produces: `ma.sh` executable with subcommand dispatch. `ma.sh`, `ma.sh -h`, `ma.sh --help`, `ma.sh help` → usage, exit 0. Unknown subcommand → usage to stderr, exit 2. `ma.sh install` with no app → error, exit 2. `ma.sh install <unknown-app>` → error naming the app, exit 2. `ma.sh install <app> <badmode>` → error listing available modes, exit 2. (The build loop is Task 5.)

- [ ] **Step 1: Write the failing test**

Create `scripts/ma_integration_test.sh`:

```sh
#!/bin/sh
# Integration tests for ma.sh. Run: sh scripts/ma_integration_test.sh
set -u
THIS_DIR=$(cd "$(dirname "$0")" && pwd)
TOP=$(cd "$THIS_DIR/.." && pwd)
MA="$TOP/ma.sh"

FAILED=0
fail() { echo "FAIL: $1"; FAILED=1; }

# usage / help
sh "$MA" >/dev/null 2>&1        || fail "no-args should exit 0"
sh "$MA" help >/dev/null 2>&1   || fail "help should exit 0"
sh "$MA" --help >/dev/null 2>&1 || fail "--help should exit 0"
sh "$MA" bogus >/dev/null 2>&1  && fail "unknown subcommand should exit nonzero"

# install arg validation (use a throwaway MA_ROOT so set_prefix is happy)
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
printf 'MA_ROOT=%s/ma\nBUILD_DIR=%s/b\nSOURCE_DIR=%s/s\n' "$T" "$T" "$T" > "$T/cfg"
export MAINSTALLER_CONFIG="$T/cfg"
sh "$TOP/setup/setup.sh" >/dev/null 2>&1

sh "$MA" install >/dev/null 2>&1                && fail "install w/o app should fail"
sh "$MA" install no_such_app >/dev/null 2>&1    && fail "install unknown app should fail"
sh "$MA" install hphi no_such_mode >/dev/null 2>&1 && fail "install bad mode should fail"

[ "$FAILED" -eq 0 ] && echo "ALL TESTS PASSED"
exit "$FAILED"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_integration_test.sh`
Expected: FAIL — `$MA` does not exist, so `sh "$MA"` errors and the `|| fail` / `&& fail` assertions trip.

- [ ] **Step 3: Write minimal implementation**

Create `ma.sh`:

```sh
#!/bin/sh
# Unified entry point for MateriApps Installer.
#   sh ma.sh install <app> [mode]   install an app and the tools it needs
#   sh ma.sh list                   list available apps/tools and versions
#   sh ma.sh installed              list installed components under MA_ROOT
#   sh ma.sh help                   show this help
set -u

MA_TOP=$(cd "$(dirname "$0")" && pwd)
export MA_TOP
. "$MA_TOP/scripts/ma_deps.sh"

ma_usage() {
  cat <<EOF
Usage: sh ma.sh <command> [args]

Commands:
  install <app> [mode]   Resolve tool dependencies, build the missing ones,
                         then install <app> (mode defaults to 'default').
  list                   List installable apps and tools with pinned versions.
  installed              List components already installed under MA_ROOT.
  help                   Show this help.
EOF
}

ma_cmd_install() {
  app="${1:-}"
  mode="${2:-default}"
  if [ -z "$app" ]; then
    echo "Error: 'install' requires an application name" >&2
    ma_usage >&2; return 2
  fi
  if [ ! -d "$MA_TOP/apps/$app" ]; then
    echo "Error: unknown app '$app' (see 'sh ma.sh list')" >&2
    return 2
  fi
  if [ ! -d "$MA_TOP/apps/$app/config/$mode" ]; then
    echo "Error: unknown mode '$mode' for '$app'. Available:" >&2
    ls -1 "$MA_TOP/apps/$app/config" >&2
    return 2
  fi
  ma_do_install "$app" "$mode"   # implemented in Task 5
}

# placeholder until Task 5; keeps arg-validation testable now
ma_do_install() { echo "install $1 (mode=$2) not yet implemented" >&2; return 0; }

case "${1:-help}" in
  -h|--help|help) ma_usage; exit 0 ;;
  install) shift; ma_cmd_install "$@"; exit $? ;;
  list)      shift; ma_cmd_list "$@";      exit $? ;;   # Task 6
  installed) shift; ma_cmd_installed "$@"; exit $? ;;   # Task 6
  *) echo "Error: unknown command '$1'" >&2; ma_usage >&2; exit 2 ;;
esac
```

Note: `ma_cmd_list`/`ma_cmd_installed` are referenced but defined in Task 6. To keep Task 4 self-contained and green, add temporary stubs right above the `case`:

```sh
ma_cmd_list() { echo "list not yet implemented" >&2; return 0; }
ma_cmd_installed() { echo "installed not yet implemented" >&2; return 0; }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `sh scripts/ma_integration_test.sh`
Expected: `ALL TESTS PASSED`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add ma.sh scripts/ma_integration_test.sh
git commit -m "feat(ma): add ma.sh CLI skeleton with dispatch and install arg validation"
```

---

### Task 5: `ma.sh install` build loop (resolve → build/skip/partial → env reload → app)

**Files:**
- Modify: `ma.sh`
- Test: `scripts/ma_integration_test.sh`

**Interfaces:**
- Consumes: `ma_resolve`, `ma_tool_status` (Tasks 2–3), `set_prefix` from `scripts/util.sh` (sets/export `MA_ROOT`), `ma_requires` (to detect "no metadata").
- Produces: `ma_do_install <app> <mode>` — the real build loop replacing the Task 4 stub.

- [ ] **Step 1: Write the failing test**

Append to `scripts/ma_integration_test.sh` (before the final summary lines). This builds a fixture repo of fake packages so no real software is compiled:

```sh
# --- fixture repo: appF -> tF2 -> tF1  (fake install.sh/link.sh) ---
REPO=$(mktemp -d)
mk_pkg() { # <kind> <name> <requires-var-line> ; creates trivial install/link
  d="$REPO/$1/$2"; mkdir -p "$d/config/default"
  { printf '__NAME__=%s\n__VERSION__=1.0\n__MA_REVISION__=1\n' "$2"
    [ -n "${3:-}" ] && printf '%s\n' "$3"; } > "$d/version.sh"
  # install.sh: record order, create the versioned prefix + vars file
  cat > "$d/install.sh" <<EOS
#!/bin/sh
. "\$(cd "\$(dirname "\$0")"/../../scripts; pwd)/util.sh"
set_prefix
echo "$2" >> "\$MA_ROOT/build-order.log"
mkdir -p "\$MA_ROOT/$2/$2-1.0-1"
: > "\$MA_ROOT/$2/${2}vars-1.0-1.sh"
EOS
  # link.sh: for tools, create env.d marker (mirrors real tools' link.sh)
  cat > "$d/link.sh" <<EOS
#!/bin/sh
. "\$(cd "\$(dirname "\$0")"/../../scripts; pwd)/util.sh"
set_prefix
if [ "$1" = tools ]; then
  mkdir -p "\$MA_ROOT/env.d"
  ln -sf "\$MA_ROOT/$2/${2}vars-1.0-1.sh" "\$MA_ROOT/env.d/${2}vars.sh"
fi
EOS
}
cp -r "$TOP/scripts" "$REPO/scripts"
cp "$TOP/ma.sh" "$REPO/ma.sh"
mkdir -p "$REPO/setup"; cp "$TOP/setup/setup.sh" "$REPO/setup/setup.sh"
cp -r "$TOP/setup/config" "$REPO/setup/config"
mk_pkg tools tF1 ""
mk_pkg tools tF2 'TF2_REQUIRES="tF1"'
mk_pkg apps  appF 'APPF_REQUIRES="tF2"'

RT=$(mktemp -d)
printf 'MA_ROOT=%s/ma\nBUILD_DIR=%s/b\nSOURCE_DIR=%s/s\n' "$RT" "$RT" "$RT" > "$RT/cfg"
env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/setup/setup.sh" >/dev/null 2>&1

# first install: builds tF1, tF2, then appF, in order
env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/ma.sh" install appF >/dev/null 2>&1 \
  || fail "ma install appF should succeed"
got=$(tr '\n' ' ' < "$RT/ma/build-order.log")
[ "$got" = "tF1 tF2 appF " ] || fail "build order expected 'tF1 tF2 appF ' got '$got'"

# re-run: tools already available -> only appF would rebuild, but its prefix
# exists so install.sh aborts; ma should report and stop nonzero WITHOUT
# rebuilding tF1/tF2 (order log unchanged for tools)
env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/ma.sh" install appF >/dev/null 2>&1
got2=$(grep -c '^tF1$' "$RT/ma/build-order.log")
[ "$got2" = "1" ] || fail "tF1 must not be rebuilt on re-run (got $got2)"

# partial tool: remove tF1 marker but keep its prefix -> ma aborts with guidance
rm -f "$RT/ma/env.d/tF1vars.sh"; rm -rf "$RT/ma/appF"   # let appF pass, block on tF1
out=$(env MAINSTALLER_CONFIG="$RT/cfg" sh "$REPO/ma.sh" install appF 2>&1)
echo "$out" | grep -q "partially installed" || fail "partial tF1 should report 'partially installed'"
rm -rf "$REPO" "$RT"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_integration_test.sh`
Expected: FAIL — `ma_do_install` is still the stub; build-order.log is never written, so the order assertion trips.

- [ ] **Step 3: Write minimal implementation**

In `ma.sh`, replace the stub `ma_do_install()` with:

```sh
ma_do_install() {
  app="$1"; mode="$2"

  . "$MA_TOP/scripts/util.sh"
  set_prefix
  if [ ! -f "$MA_ROOT/env.sh" ]; then
    echo "Error: $MA_ROOT/env.sh not found; run 'sh setup/setup.sh' first" >&2
    return 1
  fi
  . "$MA_ROOT/env.sh"

  order=$(ma_resolve "$app") || return 1   # cycle/unknown already reported

  if [ -z "$(ma_requires apps "$app")" ]; then
    echo "Notice: no dependency metadata for '$app'; assuming required tools" \
         "are already installed (install them first if the build fails)." >&2
  fi
  if [ "$mode" != default ] && [ -n "$order" ]; then
    echo "Notice: dependencies build in their default mode, not '$mode';" \
         "pre-build them in a matching toolchain if that matters." >&2
  fi

  # build/skip each tool in dependency order
  for tool in $order; do
    case "$(ma_tool_status "$tool")" in
      available) echo "== dependency '$tool' already available, skipping" ;;
      partial)
        echo "Error: '$tool' looks partially installed." >&2
        echo "Remove $MA_ROOT/$tool/$tool-* and re-run." >&2
        return 1 ;;
      absent)
        echo "== building dependency '$tool'"
        ( cd "$MA_TOP/tools/$tool" && sh install.sh && sh link.sh ) || {
          echo "Error: failed to build dependency '$tool' of '$app'" >&2
          return 1; }
        . "$MA_ROOT/env.sh" ;;   # make it visible to later checks/builds
    esac
  done

  echo "== installing app '$app' (mode=$mode)"
  ( cd "$MA_TOP/apps/$app" && sh install.sh "$mode" && sh link.sh ) || {
    echo "Error: failed to install '$app'" >&2
    return 1; }
  echo "== done: $app"
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `sh scripts/ma_integration_test.sh`
Expected: `ALL TESTS PASSED`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add ma.sh scripts/ma_integration_test.sh
git commit -m "feat(ma): implement install build loop with resume and partial-install guard"
```

---

### Task 6: `ma.sh list` and `installed`

**Files:**
- Modify: `ma.sh`
- Test: `scripts/ma_integration_test.sh`

**Interfaces:**
- Consumes: `scripts/list_maversion.sh` output style, `ma_requires` (for the `[deps]` marker), `$MA_ROOT/env.d` and `$MA_ROOT/<app>` for installed state.
- Produces: `ma_cmd_list` (apps with a `[deps]` tag when they declare `REQUIRES`, plus tools, with pinned versions) and `ma_cmd_installed` (installed tools from `env.d/*vars.sh` and apps from `<app>/<app>vars.sh`). Both exit 0.

- [ ] **Step 1: Write the failing test**

Append to `scripts/ma_integration_test.sh`:

```sh
# list: shows apps and tools; marks apps with deps
lst=$(sh "$MA" list 2>/dev/null) || fail "list should exit 0"
echo "$lst" | grep -q "hphi" || fail "list should include hphi"
echo "$lst" | grep -E "hphi.*\[deps\]" >/dev/null || fail "hphi should be marked [deps] after Task 7"
# (Task 6 lands before Task 7; this specific [deps] assertion is re-checked in Task 7.
#  For Task 6, assert the marker logic works on a fixture instead:)

# installed: reports tools (env.d) and apps (<app>/<app>vars.sh)
IT=$(mktemp -d)
printf 'MA_ROOT=%s/ma\nBUILD_DIR=%s/b\nSOURCE_DIR=%s/s\n' "$IT" "$IT" "$IT" > "$IT/cfg"
env MAINSTALLER_CONFIG="$IT/cfg" sh "$TOP/setup/setup.sh" >/dev/null 2>&1
# tool 'cmake' registers via env.d marker; app 'bar' via <app>/<app>vars.sh
mkdir -p "$IT/ma/env.d" "$IT/ma/cmake" "$IT/ma/bar"
: > "$IT/ma/cmake/cmakevars-1.0-1.sh"
ln -sf "$IT/ma/cmake/cmakevars-1.0-1.sh" "$IT/ma/env.d/cmakevars.sh"
: > "$IT/ma/bar/barvars-2.0-1.sh"
ln -sf "$IT/ma/bar/barvars-2.0-1.sh" "$IT/ma/bar/barvars.sh"
inst=$(env MAINSTALLER_CONFIG="$IT/cfg" sh "$MA" installed 2>/dev/null) || fail "installed should exit 0"
echo "$inst" | grep -q "cmake" || fail "installed should list tool cmake (env.d)"
echo "$inst" | grep -q "bar"   || fail "installed should list app bar (<app>vars)"
rm -rf "$IT"
```

Note to implementer: the `hphi ... [deps]` line above depends on Task 7 (which adds `HPHI_REQUIRES`). To keep Task 6 green on its own, replace that one assertion with a fixture check, or move it to Task 7's test. Simplest: in Task 6 assert the marker on a fixture app that declares REQUIRES; re-add the real hphi assertion in Task 7. Use:

```sh
# (Task 6 fixture for the [deps] marker)
DT=$(mktemp -d); mkdir -p "$DT/apps/withdeps/config/default" "$DT/apps/nodeps/config/default" "$DT/tools"
printf '__NAME__=withdeps\nWITHDEPS_VERSION=1\nWITHDEPS_REQUIRES="x"\n' > "$DT/apps/withdeps/version.sh"
printf '__NAME__=nodeps\nNODEPS_VERSION=1\n' > "$DT/apps/nodeps/version.sh"
mkdir -p "$DT/tools/x"; printf '__NAME__=x\nX_VERSION=1\n' > "$DT/tools/x/version.sh"
cp -r "$TOP/scripts" "$DT/scripts"; cp "$TOP/ma.sh" "$DT/ma.sh"
dlst=$(sh "$DT/ma.sh" list 2>/dev/null)
echo "$dlst" | grep -E "withdeps.*\[deps\]" >/dev/null || fail "withdeps should be [deps]"
echo "$dlst" | grep "nodeps" | grep -q "\[deps\]" && fail "nodeps must not be [deps]"
rm -rf "$DT"
```

(Remove the earlier real-hphi `[deps]` assertion from Task 6; it belongs to Task 7.)

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_integration_test.sh`
Expected: FAIL — `list`/`installed` still print the "not yet implemented" stubs.

- [ ] **Step 3: Write minimal implementation**

In `ma.sh`, replace the two stubs with:

```sh
ma_cmd_list() {
  echo "[Applications]"
  for d in "$MA_TOP"/apps/*/; do
    [ -f "$d/version.sh" ] || continue
    name=$(basename "$d")
    ver=$( . "$d/version.sh" >/dev/null 2>&1; printf '%s' "${__VERSION__:-?}" )
    if [ -n "$(ma_requires apps "$name")" ]; then tag=" [deps]"; else tag=""; fi
    printf '  %s %s%s\n' "$name" "$ver" "$tag"
  done
  echo "[Tools]"
  for d in "$MA_TOP"/tools/*/; do
    [ -f "$d/version.sh" ] || continue
    name=$(basename "$d")
    ver=$( . "$d/version.sh" >/dev/null 2>&1; printf '%s' "${__VERSION__:-?}" )
    printf '  %s %s\n' "$name" "$ver"
  done
}

ma_cmd_installed() {
  . "$MA_TOP/scripts/util.sh"; set_prefix
  # Tools register an unversioned symlink under env.d/; apps register one
  # under $MA_ROOT/<app>/<app>vars.sh (both also keep versioned files, so
  # the unversioned symlink location is what distinguishes them).
  echo "[Tools]"
  for m in "$MA_ROOT"/env.d/*vars.sh; do
    [ -e "$m" ] || continue
    printf '  %s\n' "$(basename "$m" | sed 's/vars\.sh$//')"
  done
  echo "[Applications]"
  for d in "$MA_ROOT"/*/; do
    name=$(basename "$d")
    [ -e "$d${name}vars.sh" ] || continue
    printf '  %s\n' "$name"
  done
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `sh scripts/ma_integration_test.sh`
Expected: `ALL TESTS PASSED`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add ma.sh scripts/ma_integration_test.sh
git commit -m "feat(ma): add list (with [deps] marker) and installed subcommands"
```

---

### Task 7: version.sh declarative-only lint + populate hphi-chain REQUIRES

**Files:**
- Create: `scripts/lint_version_sh.sh`
- Modify: `apps/hphi/version.sh`, `tools/scalapack/version.sh`
- Test: `scripts/ma_deps_test.sh` (lint unit test) + a real-tree check

**Interfaces:**
- Produces: `scripts/lint_version_sh.sh [files...]` — exits nonzero and prints offending lines if any given `version.sh` has a non-comment, non-blank line that is not a simple assignment (`NAME=...` or `export NAME=...`; a `$(...)` on the right-hand side is allowed, as in `tools/openmpi/version.sh`). With no args it checks all `apps/*/version.sh` and `tools/*/version.sh`.

- [ ] **Step 1: Write the failing test**

Append to `scripts/ma_deps_test.sh`:

```sh
# --- lint_version_sh ---
LINT="$THIS_DIR/lint_version_sh.sh"
ok="$FIX/ok.sh"; bad="$FIX/bad.sh"; subst="$FIX/subst.sh"
printf '# comment\nFOO="1.0"\nexport BAR=baz\n' > "$ok"
printf 'FOO=1\nrm -rf /tmp/x\n' > "$bad"
printf 'V=$(echo 1 | tr a b)\n' > "$subst"
sh "$LINT" "$ok"    || fail "lint should accept assignments+comments"
sh "$LINT" "$subst" || fail "lint should accept assignment with command substitution"
sh "$LINT" "$bad"   && fail "lint should reject a bare command"

# real tree must be clean (all current version.sh are declarative)
sh "$LINT" || fail "all repo version.sh should pass the declarative lint"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `sh scripts/ma_deps_test.sh`
Expected: FAIL — `scripts/lint_version_sh.sh` does not exist.

- [ ] **Step 3: Write minimal implementation**

Create `scripts/lint_version_sh.sh`:

```sh
#!/bin/sh
# Assert that each version.sh is declarative (only comments/blank lines and
# simple `NAME=...` or `export NAME=...` assignments). A $(...) on the RHS is
# allowed. Exits nonzero listing offenders.
set -u
SELF_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$SELF_DIR")

if [ "$#" -gt 0 ]; then set -- "$@"; else
  set -- "$ROOT"/apps/*/version.sh "$ROOT"/tools/*/version.sh
fi

rc=0
for f in "$@"; do
  [ -f "$f" ] || continue
  # strip comments and blank lines, then flag any line that is not an
  # (export) NAME=... assignment.
  bad=$(sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$f" \
        | grep -vE '^[[:space:]]*(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*=' || true)
  if [ -n "$bad" ]; then
    echo "Non-declarative line(s) in $f:" >&2
    printf '%s\n' "$bad" >&2
    rc=1
  fi
done
exit "$rc"
```

- [ ] **Step 4: Run the lint test to verify it passes**

Run: `sh scripts/ma_deps_test.sh`
Expected: `ALL TESTS PASSED`.

- [ ] **Step 5: Populate the hphi-chain REQUIRES**

Edit `apps/hphi/version.sh` — append (keep existing lines):

```sh
# Tools this app needs (used by ma.sh dependency resolution).
HPHI_REQUIRES="cmake openmpi scalapack"
```

Edit `tools/scalapack/version.sh` — append:

```sh
# Tools this tool needs (used by ma.sh dependency resolution).
SCALAPACK_REQUIRES="openmpi lapack"
```

(`cmake`, `openmpi`, `lapack` declare no `REQUIRES`.)

- [ ] **Step 6: Verify resolve + lint on the real tree**

Run:
```bash
sh -c '. scripts/ma_deps.sh; MA_TOP=$(pwd) ma_resolve hphi'
```
Expected (order may interleave cmake, but openmpi before scalapack, lapack before scalapack):
```
cmake
openmpi
lapack
scalapack
```
Run: `sh scripts/lint_version_sh.sh`  → exit 0 (clean).
Run: `sh scripts/ma_deps_test.sh`     → `ALL TESTS PASSED`.

- [ ] **Step 7: Add the real hphi `[deps]` assertion**

Append to `scripts/ma_integration_test.sh`:

```sh
echo "$(sh "$MA" list 2>/dev/null)" | grep -E "hphi .*\[deps\]" >/dev/null \
  || fail "hphi should be marked [deps]"
```
Run: `sh scripts/ma_integration_test.sh` → `ALL TESTS PASSED`.

- [ ] **Step 8: Commit**

```bash
git add scripts/lint_version_sh.sh scripts/ma_deps_test.sh scripts/ma_integration_test.sh \
        apps/hphi/version.sh tools/scalapack/version.sh
git commit -m "feat(ma): add version.sh declarative lint and hphi-chain REQUIRES metadata"
```

---

### Task 8: CI wiring

**Files:**
- Modify: `.github/workflows/main.yml`

**Interfaces:**
- Consumes: the test scripts and lint from Tasks 1–7.
- Produces: a `ma` job that runs shellcheck over `ma.sh`/`scripts/ma_deps.sh`/`scripts/lint_version_sh.sh`, the declarative lint, and both test scripts.

- [ ] **Step 1: Add the job**

Edit `.github/workflows/main.yml` — add under `jobs:` (sibling of the existing `shellcheck`/`apps` jobs; assumes the `shellcheck` job from PR #178 exists — if not, install shellcheck here):

```yaml
  ma:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4
      - name: shellcheck ma scripts
        run: |
          sudo apt-get update && sudo apt-get -y install shellcheck
          shellcheck --severity=warning -s sh ma.sh scripts/ma_deps.sh scripts/lint_version_sh.sh
      - name: version.sh declarative lint
        run: sh scripts/lint_version_sh.sh
      - name: resolver unit tests
        run: sh scripts/ma_deps_test.sh
      - name: ma.sh integration tests
        run: sh scripts/ma_integration_test.sh
```

- [ ] **Step 2: Validate the workflow locally**

Run:
```bash
python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/main.yml')); print('yaml ok')"
shellcheck --severity=warning -s sh ma.sh scripts/ma_deps.sh scripts/lint_version_sh.sh
sh scripts/ma_deps_test.sh && sh scripts/ma_integration_test.sh
```
Expected: `yaml ok`, shellcheck clean, both test scripts `ALL TESTS PASSED`.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/main.yml
git commit -m "ci: run ma.sh shellcheck, version.sh lint, and ma test scripts"
```

---

### Task 9: Documentation

**Files:**
- Modify: `README.md`, `docs/sphinx/en/source/how_to_use/index.rst`, `docs/sphinx/ja/source/how_to_use/index.rst`

**Interfaces:** none (docs only).

- [ ] **Step 1: README quick path**

In `README.md`, under `# Quick Usage`, add a short subsection after the numbered list:

```markdown
## Quick install with `ma.sh`

For apps that declare their tool dependencies, a single command builds the
missing tools (in dependency order) and then the app:

    sh ma.sh install hphi        # build cmake/openmpi/scalapack as needed, then HPhi
    sh ma.sh list                # available apps/tools ([deps] = auto-resolves tools)
    sh ma.sh installed           # what is already installed

Automatic dependency resolution applies only to apps tagged `[deps]` in
`sh ma.sh list`; for other apps `ma.sh` installs just that app and you install
its tools first (the per-directory flow below). `ma.sh` builds tools in their
default mode.
```

- [ ] **Step 2: how_to_use (en)**

In `docs/sphinx/en/source/how_to_use/index.rst`, add a subsection at the start of `Install` presenting `ma.sh install <app>` as the quick path and pointing to the existing per-directory steps as the detailed/complete path. Include the `[deps]`-only caveat and the default-mode note. (Mirror the README wording.)

- [ ] **Step 3: how_to_use (ja)**

Add the equivalent Japanese subsection to `docs/sphinx/ja/source/how_to_use/index.rst`.

- [ ] **Step 4: Build docs to check for warnings**

Run:
```bash
( cd docs/sphinx/en && python3 -m sphinx -b html -q source /tmp/ma-en ) 2>&1 | grep -i "how_to_use" || echo "en clean"
( cd docs/sphinx/ja && python3 -m sphinx -b html -q source /tmp/ma-ja ) 2>&1 | grep -i "how_to_use" || echo "ja clean"
rm -rf /tmp/ma-en /tmp/ma-ja
```
Expected: `en clean` / `ja clean` (no how_to_use warnings).

- [ ] **Step 5: Commit**

```bash
git add README.md docs/sphinx/en/source/how_to_use/index.rst docs/sphinx/ja/source/how_to_use/index.rst
git commit -m "docs: document ma.sh as the quick install path"
```

---

## Notes for the implementer

- Run everything from the repo root. Test scripts derive paths from their own
  location, so they also work from elsewhere.
- `set_prefix` (in `scripts/util.sh`) exports `MA_ROOT`/`BUILD_DIR`/`SOURCE_DIR`;
  the tests set `MAINSTALLER_CONFIG` to a throwaway config so they never touch a
  real install tree.
- The integration test deliberately uses fake packages so CI stays fast and
  deterministic; the existing `apps` matrix already builds real apps (hphi,
  tenes, ...) via their own `install.sh`.
