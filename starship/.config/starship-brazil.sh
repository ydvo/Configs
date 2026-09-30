#!/usr/bin/env bash
# Fast Brazil-workspace detector for the starship prompt.
# Prints "<workspace>:<package>" (or just "<workspace>") when the current
# directory is inside a Brazil workspace, otherwise prints nothing.
# Pure filesystem walk-up — no `brazil` CLI call — so it is prompt-fast.
set -euo pipefail

dir="${1:-$PWD}"
ws_root=""

# Walk up looking for the workspace marker (.brazil dir at the root).
d="$dir"
while [ "$d" != "/" ] && [ -n "$d" ]; do
  if [ -d "$d/.brazil" ]; then
    ws_root="$d"
    break
  fi
  d="$(dirname "$d")"
done

# Not in a workspace -> exit non-zero so the starship custom module (when=true,
# which tests exit status) stays hidden instead of rendering an empty prefix.
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
