#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WURST_HOME="${WURST_HOME:-$ROOT/.tools/wurst-compiler}"
WURST="$WURST_HOME/wurstscript"
JASS="$ROOT/.tools/jass"
MAP_IN="${1:-$ROOT/LastFortress.w3x}"
MAP_OUT="$ROOT/dist/coop_last_fortress.w3x"
LIB="$ROOT/_build/dependencies/wurstStdlib2"

if [[ ! -x "$WURST" ]]; then
  echo "Missing wurstscript at $WURST"
  echo "Run: tools/bootstrap_toolchain.sh"
  exit 1
fi

if [[ ! -d "$LIB/wurst" ]]; then
  echo "Missing stdlib at $LIB"
  echo "Run: tools/bootstrap_toolchain.sh"
  exit 1
fi

mkdir -p "$ROOT/dist" "$ROOT/_build"

echo "Building $MAP_OUT from $MAP_IN ..."
set +e
"$WURST" \
  -build \
  -workspaceroot "$ROOT" \
  -inputmap "$MAP_IN" \
  -runcompiletimefunctions \
  -injectobjects \
  -stacktraces \
  -noPJass \
  -lib "$LIB" \
  "$JASS/common.j" \
  "$JASS/blizzard.j" \
  "$ROOT/wurst"
status=$?
set -e
if [[ $status -ne 0 ]]; then
  echo "Wurst compile failed (exit $status)"
  exit $status
fi

# Prefer compiler-chosen output if present
if [[ -f "$ROOT/_build/coop_last_fortress.w3x" ]]; then
  cp -f "$ROOT/_build/coop_last_fortress.w3x" "$MAP_OUT"
elif [[ -f "$ROOT/_build/LastFortress.w3x" ]]; then
  cp -f "$ROOT/_build/LastFortress.w3x" "$MAP_OUT"
else
  # Fallback: some builds overwrite adjacent to input
  found="$(find "$ROOT/_build" -name '*.w3x' | head -1 || true)"
  if [[ -n "$found" ]]; then
    cp -f "$found" "$MAP_OUT"
  else
    echo "Build finished but no output map found under _build/. Check compiler log."
    exit 1
  fi
fi

echo "OK: $MAP_OUT"
ls -la "$MAP_OUT"
