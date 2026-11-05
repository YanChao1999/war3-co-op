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

# 1.31 common.j for compile (stdlib requires it). Do not binary-patch the MPQ —
# that previously made 1.27a unable to create the game.
if [[ -f "$JASS/1.31/common.j" ]]; then
  COMMON_J="$JASS/1.31/common.j"
  BLIZZ_J="$JASS/1.31/blizzard.j"
else
  COMMON_J="$JASS/common.j"
  BLIZZ_J="$JASS/blizzard.j"
fi
cp -f "$COMMON_J" "$ROOT/_build/common.j"
cp -f "$BLIZZ_J" "$ROOT/_build/blizzard.j"
echo "Using compile natives from: $COMMON_J"

# Replace BlzGroup* helpers with ForGroup fallbacks (still valid on 1.31 / 1.27a).
python3 "$ROOT/tools/patch_stdlib_127a.py"

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
  "$COMMON_J" \
  "$BLIZZ_J" \
  "$ROOT/wurst"
status=$?
set -e
if [[ $status -ne 0 ]]; then
  echo "Wurst compile failed (exit $status)"
  exit $status
fi

if [[ -f "$ROOT/_build/coop_last_fortress.w3x" ]]; then
  cp -f "$ROOT/_build/coop_last_fortress.w3x" "$MAP_OUT"
elif [[ -f "$ROOT/_build/LastFortress.w3x" ]]; then
  cp -f "$ROOT/_build/LastFortress.w3x" "$MAP_OUT"
else
  found="$(find "$ROOT/_build" -name '*.w3x' | head -1 || true)"
  if [[ -n "$found" ]]; then
    cp -f "$found" "$MAP_OUT"
  else
    echo "Build finished but no output map found under _build/."
    exit 1
  fi
fi

if [[ -f "$ROOT/_build/02_compiled.j.txt" ]] && rg -q "BlzGroup" "$ROOT/_build/02_compiled.j.txt"; then
  echo "ERROR: BlzGroup* still in script"
  rg -n "BlzGroup" "$ROOT/_build/02_compiled.j.txt" | head
  exit 1
fi

echo "OK: $MAP_OUT (clean MPQ, no binary strip)"
if [[ -f "$ROOT/_build/02_compiled.j.txt" ]] && rg -q "BlzBitOr" "$ROOT/_build/02_compiled.j.txt"; then
  echo "NOTE: script still calls BlzBitOr (1.27a may exit after start). Create-game should work."
fi
ls -la "$MAP_OUT"
