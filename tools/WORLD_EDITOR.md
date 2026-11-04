# World Editor checklist — The Last Fortress

The MVP **creates fortress, outposts, mines, and bases in script**, so the starter `LastFortress.w3x` / `maps/last_fortress/template.w3x` is enough to play.

Use the World Editor (or HiveWE) when you want authored terrain:

## Required for a polished map

1. Open `maps/last_fortress/template.w3x` (copy of the playable terrain map).
2. Paint a defendable center plateau for the fortress.
3. Place two start locations for Player 1 and Player 2 (slots 0 and 1).
4. Optionally place regions named for future scripting:
   - `fortress`
   - `spawn_north`, `spawn_east`, `spawn_west`
   - `outpost_1`, `outpost_2`, `outpost_3`
   - `base_arthas`, `base_thrall`
5. Add trees around both bases (lumber). Script still spawns gold mines.
6. Player 11 (slot 10) = Scourge computer — no start town required.
7. Scenario → Player Properties: 2 users allied, computer undead enemy.
8. Save **without** overwriting compiled script if you inject via Wurst build (Wurst treats the terrain map as read-only input).

## Build flow

```bash
./tools/bootstrap_toolchain.sh   # once
./tools/build.sh                 # -> dist/coop_last_fortress.w3x
```

Host `dist/coop_last_fortress.w3x` in Warcraft III Custom Games (Classic / TFT).
