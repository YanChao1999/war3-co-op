# Warcraft III: Co-op Commanders

Classic / The Frozen Throne custom map — SC2-inspired **Co-op Commanders** MVP.

**Mission:** The Last Fortress  
**Commanders:** Arthas (Scourge) + Thrall (Horde)

## Play (quick)

1. Build the map (below) or use a released `dist/coop_last_fortress.w3x`.
2. Host a Custom Game with **2 players** on slots 1–2.
3. In-game chat:
   - `-pick arthas` or `-pick thrall` (must be unique)
   - optional `-load W3C-....` for progression
   - solo convenience: `-autostart`
4. Defend the fortress for 25:00, destroy outposts for bonus XP, survive the final Lich assault.
5. Copy your save code from the results printout.

### Commander abilities

| Commander | Special | Ultimate |
|-----------|---------|----------|
| Arthas | `-raise` (Souls) | `-army` |
| Thrall | `-elemental` (Spirit) | `-storm` |

## Build from source

**Requirements:** Linux x64 (or Wurst on Windows via VS Code), network for first toolchain download.

```bash
./tools/bootstrap_toolchain.sh   # Wurst 2.0.0 + stdlib + starter map
./tools/build.sh                 # -> dist/coop_last_fortress.w3x
```

Toolchain lives under `.tools/` and `_build/` (gitignored). Map terrain input: `LastFortress.w3x` / `maps/last_fortress/template.w3x`.

World Editor notes: [`tools/WORLD_EDITOR.md`](tools/WORLD_EDITOR.md)  
Playtest checklist: [`tools/PLAYTEST.md`](tools/PLAYTEST.md)

## Project layout

```
docs/           GDD, commander & mission sheets
wurst/          WurstScript gameplay systems
maps/           Terrain template
data/           Design tables
tools/          bootstrap, build, WE & playtest docs
dist/           Built playable .w3x
```

## Design docs

- [GDD](docs/GDD.md)
- [Arthas](docs/commanders/arthas.md) · [Thrall](docs/commanders/thrall.md)
- [The Last Fortress](docs/missions/last_fortress.md)

## Stack

- **WurstScript** → synchronized JASS  
- **WurstStdlib2**  
- Classic multiplayer map (no external services during match)  
- Progression via **save codes** (Classic-safe)

## License

Map content and scripts in this repository — see project license when added. Warcraft III is © Blizzard Entertainment.
