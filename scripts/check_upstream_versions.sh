#!/bin/sh
# Compare the pinned version of each GitHub-hosted package with the
# latest upstream release and report outdated ones.
#
# Usage: sh scripts/check_upstream_versions.sh [--create-issues]
#
# Only packages whose download.sh fetches a github.com URL versioned by
# __VERSION__ are checked; upstreams without GitHub releases are
# skipped. Requires an authenticated gh CLI (in GitHub Actions, set
# GH_TOKEN=${{ github.token }}).
#
# With --create-issues, an issue titled "[<name>] New upstream version
# <version>" is opened for each outdated package unless an open issue
# with the same title already exists.
#
# Exits nonzero if any GitHub API call fails for a reason other than
# "no releases" (auth, rate limit, network), so a scheduled run cannot
# silently skip everything.

set -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT_DIR=$(dirname "$SCRIPT_DIR")
CREATE_ISSUES=${1:-}

outdated=0
errors=0
for dir in "$ROOT_DIR"/apps/* "$ROOT_DIR"/tools/*; do
  [ -d "$dir" ] || continue
  [ -f "$dir/version.sh" ] || continue
  [ -f "$dir/download.sh" ] || continue
  name=$(basename "$dir")

  # the URL versioned by __VERSION__ -- braced or not, but not
  # e.g. __VERSION_BLAS__ -- ignoring commented-out lines
  url_line=$(grep 'github\.com' "$dir/download.sh" \
    | grep -E '\$(\{__VERSION__\}|__VERSION__([^A-Za-z0-9_]|$))' \
    | grep -v '^[[:space:]]*#' | head -1)
  [ -n "$url_line" ] || continue
  url_line=$(echo "$url_line" | sed -e "s/\${__NAME__}/$name/g" -e "s/\"\$__NAME__\"/$name/g")
  ownerrepo=$(echo "$url_line" | sed -n 's%.*github\.com/\([^/]*\)/\([^/"]*\)/.*%\1/\2%p')
  [ -n "$ownerrepo" ] || continue
  case "$ownerrepo" in
    *'$'*) continue ;; # unresolved shell variable in the URL
  esac

  pinned=$( (. "$dir/version.sh" >/dev/null 2>&1; echo "${__VERSION__:-}") )
  [ -n "$pinned" ] || continue

  api_out=$(gh api "repos/$ownerrepo/releases/latest" -q .tag_name 2>&1)
  api_status=$?
  if [ $api_status -ne 0 ]; then
    case "$api_out" in
      *"Not Found"*|*"HTTP 404"*)
        echo "skip     $name ($ownerrepo): no GitHub releases"
        ;;
      *)
        echo "ERROR    $name ($ownerrepo): gh api failed: $api_out"
        errors=$((errors + 1))
        ;;
    esac
    continue
  fi
  latest=$api_out
  # tags come as 3.6.0, v3.6.0, v.1.5.0, qe-7.0, ... : drop the prefix
  latest_norm=$(echo "$latest" | sed 's/^[^0-9]*//')

  if [ "$latest_norm" = "$pinned" ]; then
    echo "ok       $name: $pinned"
    continue
  fi
  # a pin like 1.0-beta is older than the released 1.0 even though
  # sort -V may order it after
  pinned_base=${pinned%%-*}
  if [ "$pinned" != "$pinned_base" ] && [ "$latest_norm" = "$pinned_base" ]; then
    :
  else
    # only report if the upstream release is really newer (some
    # upstreams tag formal releases less often than we pin)
    newer=$(printf '%s\n%s\n' "$pinned" "$latest_norm" | sort -V | tail -1)
    if [ "$newer" = "$pinned" ]; then
      echo "ok       $name: $pinned (latest GitHub release is older: $latest_norm)"
      continue
    fi
  fi

  echo "OUTDATED $name: pinned $pinned, latest $latest_norm ($ownerrepo)"
  outdated=$((outdated + 1))

  if [ "$CREATE_ISSUES" = "--create-issues" ]; then
    title="[$name] New upstream version $latest_norm"
    if gh issue list --state open --limit 500 \
         --json title --jq '.[].title' | grep -Fxq "$title"; then
      echo "         issue already open: $title"
    else
      gh issue create --title "$title" --body "The upstream release of \`$name\` (https://github.com/$ownerrepo) is now **$latest_norm**, while \`version.sh\` pins **$pinned**.

To update:
1. Bump the version (and reset the MA_REVISION to 1) in the package's \`version.sh\`
2. Check whether the URL pattern in \`download.sh\` still matches
3. Rename or drop stale \`patch/$name-$pinned.patch\` files if present

_Opened automatically by the version watch workflow._"
      echo "         issue created: $title"
    fi
  fi
done

echo "-----"
echo "$outdated package(s) outdated, $errors API error(s)"
[ "$errors" -eq 0 ] || exit 1
exit 0
