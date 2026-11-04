# Mission: The Last Fortress

**Archetype:** Hold the Line  
**Duration:** 1500 seconds (25:00)  
**Difficulty (MVP):** Normal only  

## Primary objective

Survive until the mission timer completes without losing the central fortress (Castle).

## Optional objectives

Destroy **3** Scourge outposts (Necropolises) for bonus XP (`+80` each).

## Final event

Wave 8 (FINAL ASSAULT) spawns a **Lich** boss with multi-angle reinforcements. Killing the Lich awards boss XP; survival remains the primary win condition.

## Wave table (base times; ± sync RNG jitter)

| Wave | ~Time | Tier | Notes |
|------|-------|------|-------|
| 1 | 1:30 | Infantry | Ghouls / skeletons |
| 2 | 3:30 | Infantry | |
| 3 | 6:00 | Mixed | + Crypt Fiends / Necromancers |
| 4 | 8:40 | Mixed | |
| 5 | 12:00 | Siege | Aboms / Meat Wagons |
| 6 | 15:00 | Siege | |
| 7 | 19:00 | Elite | Frost Wyrms mix |
| 8 | 23:00 | Boss | Lich + multi-spawn |

## Layout (script-authored on template map)

- Fortress at map center  
- Commander bases SW / SE of center  
- Outposts NE, NW, South  
- Enemy spawns North / East / West  

## Victory / Defeat

- **Victory:** Timer elapsed; if final wave already spawned, boss must not still be alive  
- **Defeat:** Fortress destroyed  

## Chat / lobby

- `-pick arthas` / `-pick thrall`  
- `-load W3C-...`  
- `-autostart` — solo convenience (fills the other commander)  
