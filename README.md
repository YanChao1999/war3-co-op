# Warcraft III: Co-op Commanders

Classic / The Frozen Throne custom map — SC2-inspired **Co-op Commanders** MVP.

**任务：** 最后的要塞  
**指挥官：** 阿尔萨斯 / 萨尔 / 泰兰德 / 吉安娜 / 伊利丹 / 守望者 / 雷克萨

## Play (quick)

1. Build the map (below) or use a released `dist/coop_last_fortress.w3x`.
2. Host a Custom Game with **2 players** on slots 1–2.
3. In-game chat:
   - `-pick arthas|thrall|tyrande|jaina|illidan|watcher|rexxar`（或中文名，不可重复）
   - optional `-load W3C7-....` for progression
   - solo convenience: `-autostart`
4. Defend the fortress for 25:00, destroy outposts for bonus XP, survive the final Lich assault.
5. Copy your save code from the results printout.

### Commander abilities

| 指挥官 | 技能 | 终极 |
|--------|------|------|
| 阿尔萨斯 | `-raise`（灵魂） | `-army` |
| 萨尔 | `-elemental`（灵能） | `-storm` |
| 泰兰德 | `-ambush`（月能） | `-lunar` |
| 吉安娜 | `-arcane`（奥术能） | `-blizzard` |
| 伊利丹 | `-consume`（献祭友军→邪能） | `-meta` 恶魔变身 |
| 守望者 | `-blink`（复仇闪现） | `-avatar` 复仇化身 |
| 雷克萨 | `-revive`（救同伴） | `-beasts` 召野兽（无常规军队，仅三英雄） |

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
- [阿尔萨斯](docs/commanders/arthas.md) · [萨尔](docs/commanders/thrall.md) · [泰兰德](docs/commanders/tyrande.md) · [吉安娜](docs/commanders/jaina.md) · [伊利丹](docs/commanders/illidan.md) · [守望者](docs/commanders/watcher.md) · [雷克萨](docs/commanders/rexxar.md)
- [The Last Fortress](docs/missions/last_fortress.md)

## Stack

- **WurstScript** → synchronized JASS  
- **WurstStdlib2**  
- Classic multiplayer map (no external services during match)  
- Progression via **save codes** (Classic-safe)

## License

Map content and scripts in this repository — see project license when added. Warcraft III is © Blizzard Entertainment.
