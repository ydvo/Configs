#!/usr/bin/env bash
# Fast Brazil-workspace detector for the starship prompt.
#
# Usage: starship-brazil.sh [name|state] [dir]
#   name  (default) -> prints "<workspace>:<package>" (or "<workspace>").
#   state           -> prints a sync-state marker only, for a separately
#                      colored starship module:
#                          "↓"  version set moved ahead of this workspace
#                               (authoritative; flag set out-of-band by
#                               starship-brazil-check.sh)
#                          "?"  VS metadata not synced in a while (cheap
#                               local proxy; VS may or may not have moved)
#
# In every mode the script exits non-zero (and prints nothing) when there is
# nothing to show, so the starship custom module using it as `when` stays hidden.
#
# This is on the prompt hot path: local filesystem work only (a directory
# walk-up plus a couple of stat/reads). No `brazil` CLI calls, no network.
# The authoritative "behind" check is in starship-brazil-check.sh (out-of-band);
# here we only read the flag file it leaves behind.
set -euo pipefail

# Seconds since last VS-metadata sync before we show the cheap "stale?" nudge.
STALE_AFTER="${STARSHIP_BRAZIL_STALE_AFTER:-604800}"  # 7 days

mode="name"
case "${1:-}" in
  name|state) mode="$1"; shift ;;
esac
dir="${1:-$PWD}"

# Walk up looking for the workspace-root marker. The canonical marker in modern
# Brazil (the Ruby `brazil ws` CLI) is the `packageInfo` file at the root, which
# is what Brazil-aware tooling keys on. (An older `.brazil` dir only appears as a
# fallback in some scripts, so keying on it misses real workspaces.)
ws_root=""
d="$dir"
while [ "$d" != "/" ] && [ -n "$d" ]; do
  if [ -e "$d/packageInfo" ]; then
    ws_root="$d"
    break
  fi
  d="$(dirname "$d")"
done

# Not in a workspace -> exit non-zero so the starship module stays hidden.
[ -z "$ws_root" ] && exit 1

# --- name mode: workspace[:package] ---------------------------------------
if [ "$mode" = "name" ]; then
  ws_name="$(basename "$ws_root")"
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
  exit 0
fi

# --- state mode: sync marker (cheap, local only) --------------------------
# The version set name lives in packageInfo as:  versionSet = Group/Name;
vs=""
if line="$(grep -m1 -E '^[[:space:]]*versionSet[[:space:]]*=' "$ws_root/packageInfo" 2>/dev/null)"; then
  vs="${line#*=}"; vs="${vs%%;*}"; vs="${vs//[[:space:]]/}"
fi
[ -z "$vs" ] && exit 1

# Authoritative flag written by the out-of-band checker; '/' flattened to '_'.
behind_flag="$ws_root/release-info/.behind-${vs//\//_}"
# Base VS file (NOT the .json sibling) is rewritten only by a metadata sync, so
# its mtime is the reliable "last synced" timestamp.
vs_file="$ws_root/release-info/versionSets/$vs"

if [ -f "$behind_flag" ]; then
  printf '↓'          # version set has moved ahead of this workspace
  exit 0
elif [ -f "$vs_file" ]; then
  now="$(date +%s)"
  mtime="$(stat -c %Y "$vs_file" 2>/dev/null || echo "$now")"
  if [ $(( now - mtime )) -gt "$STALE_AFTER" ]; then
    printf '?'        # metadata not synced in a while (cheap local proxy)
    exit 0
  fi
fi

# In sync (or can't tell) -> nothing to show.
exit 1
