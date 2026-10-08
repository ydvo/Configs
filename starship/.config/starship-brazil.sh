#!/usr/bin/env bash
# Fast Brazil-workspace detector for the starship prompt.
# Prints "<workspace>:<package>" (or just "<workspace>") when the current
# directory is inside a Brazil workspace, otherwise prints nothing and exits
# non-zero so the starship custom module stays hidden.
# Pure filesystem walk-up — no `brazil` CLI call, no network — so it is
# prompt-fast.
set -euo pipefail

dir="${1:-$PWD}"
ws_root=""

# Walk up looking for the workspace-root marker. The canonical marker in modern
# Brazil (the Ruby `brazil ws` CLI) is the `packageInfo` file at the root, which
# is what Brazil-aware tooling keys on.
d="$dir"
while [ "$d" != "/" ] && [ -n "$d" ]; do
  if [ -e "$d/packageInfo" ]; then
    ws_root="$d"
    break
  fi
  d="$(dirname "$d")"
done

# Not in a workspace -> exit non-zero so the starship custom module stays hidden.
[ -z "$ws_root" ] && exit 1

ws_name="$(basename "$ws_root")"

# If we're inside src/<Package>/..., surface the package name too.
pkg=""
case "$dir" in
  "$ws_root"/src/*)
    rest="${dir#"$ws_root"/src/}"
    pkg="${rest%%/*}"
    ;;
esac

if [ -n "$pkg" ]; then
  printf '%s:%s' "$ws_name" "$pkg"
else
  printf '%s' "$ws_name"
fi
