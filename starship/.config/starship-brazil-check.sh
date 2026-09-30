#!/usr/bin/env bash
# Out-of-band Brazil-workspace staleness checker for the starship prompt.
#
# For the workspace containing the given directory, this compares the locally
# synced version-set revision (eventId, read from the cached VS metadata) to the
# current tip revision from BMDS (`brazil vs history`), and writes or clears a
# flag file that the prompt-hot-path detector (starship-brazil.sh) reads:
#
#     release-info/.behind-<vs>   present => workspace is behind its version set
#
# This DOES A NETWORK CALL (needs a Midway session) and takes ~0.5s+, so it must
# NOT run on the prompt hot path. It is meant to be fired detached/in-background
# from a precmd hook, throttled so it hits the network at most once per interval.
# It is strictly read-only: it never runs `brazil ws sync` and never mutates the
# workspace — it only reads local metadata and writes its own flag/stamp files.
set -euo pipefail

# Minimum seconds between real network checks per workspace.
CHECK_INTERVAL="${STARSHIP_BRAZIL_CHECK_INTERVAL:-3600}"  # 1 hour

dir="${1:-$PWD}"

# --- locate workspace root (same marker as the detector) ------------------
ws_root=""
d="$dir"
while [ "$d" != "/" ] && [ -n "$d" ]; do
  if [ -e "$d/packageInfo" ]; then
    ws_root="$d"
    break
  fi
  d="$(dirname "$d")"
done
[ -z "$ws_root" ] && exit 0   # not in a workspace, nothing to do

# --- version set name from packageInfo ------------------------------------
vs=""
if line="$(grep -m1 -E '^[[:space:]]*versionSet[[:space:]]*=' "$ws_root/packageInfo" 2>/dev/null)"; then
  vs="${line#*=}"; vs="${vs%%;*}"; vs="${vs//[[:space:]]/}"
fi
[ -z "$vs" ] && exit 0

safe_vs="${vs//\//_}"
info_dir="$ws_root/release-info"
[ -d "$info_dir" ] || exit 0     # never synced metadata -> nothing to compare
stamp="$info_dir/.behind-check-stamp-$safe_vs"
behind_flag="$info_dir/.behind-$safe_vs"

# --- throttle: skip if we checked recently --------------------------------
if [ -f "$stamp" ]; then
  now="$(date +%s)"
  last="$(stat -c %Y "$stamp" 2>/dev/null || echo 0)"
  [ $(( now - last )) -lt "$CHECK_INTERVAL" ] && exit 0
fi

# Simple lock so overlapping prompts don't launch concurrent network checks.
lock="$info_dir/.behind-check-lock-$safe_vs"
if ! ( set -o noclobber; : > "$lock" ) 2>/dev/null; then
  exit 0
fi
trap 'rm -f "$lock"' EXIT

# --- local synced eventId (no network) ------------------------------------
# Prefer the JSON sibling (cheap to parse); the eventId field is the synced rev.
local_eid=""
json="$info_dir/versionSets/$vs.json"
if [ -f "$json" ]; then
  if command -v jq >/dev/null 2>&1; then
    local_eid="$(jq -r '.eventId // empty' "$json" 2>/dev/null || true)"
  else
    # Fallback: grep the eventId out of the JSON without jq.
    local_eid="$(grep -oE '"eventId"[[:space:]]*:[[:space:]]*"?[0-9]+' "$json" 2>/dev/null \
                  | head -n1 | grep -oE '[0-9]+' || true)"
  fi
fi
[ -z "$local_eid" ] && exit 0    # can't determine local rev -> don't guess

# --- tip eventId from BMDS (network + Midway) -----------------------------
# `brazil vs history` output line format: #b<rev> @b<eventId> on <date> by <user>
tip_line="$(brazil vs history --short --max 1 -vs "$vs" 2>/dev/null | grep -m1 '^#' || true)"
[ -z "$tip_line" ] && exit 0     # offline / no Midway / lookup failed -> leave flag as-is

tip_eid="$(sed -E 's/.*@b?([0-9]+).*/\1/' <<<"$tip_line")"
[ -z "$tip_eid" ] && exit 0

# --- record result --------------------------------------------------------
if [ "$local_eid" != "$tip_eid" ]; then
  : > "$behind_flag"
else
  rm -f "$behind_flag"
fi

# Mark the successful check time (throttle anchor). Only stamp on a real,
# completed network comparison so failures retry next prompt.
: > "$stamp"
