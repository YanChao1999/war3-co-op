# Two-player playtest checklist — The Last Fortress

Build: `./tools/build.sh` → host `dist/coop_last_fortress.w3x`.

## Lobby

- [ ] Both players can join custom game  
- [ ] `-load W3C-1000-1000-??` accepts/rejects correctly  
- [ ] Duplicate picks blocked (`arthas`+`arthas`)  
- [ ] Unique picks start the mission  
- [ ] Solo: `-autostart` assigns the other commander  

## Early game

- [ ] Both bases + mines + workers spawn  
- [ ] Fortress visible at center  
- [ ] Three outposts exist with guards  
- [ ] Multiboard shows timer / next wave / resources  

## Combat

- [ ] Wave 1 arrives ~1:30 and attacks fortress  
- [ ] Killing enemies grants Souls / Spirit  
- [ ] `-raise` / `-elemental` gated by level + resource cost  
- [ ] Destroying an outpost increments optional counter + XP message  

## Late game

- [ ] Siege/elite waves include wagons / aboms / wyrms  
- [ ] Final assault announces Lich  
- [ ] Fortress death → Defeat + results/save code  
- [ ] Timer complete → Victory + results/save code  

## Sync / edge

- [ ] Both clients stay synced (no desync on waves)  
- [ ] Player leave mid-game does not soft-lock ally *(observe)*  
- [ ] Late-game unit counts remain playable on target patch  

## Balance notes (initial)

- Starting gold/lumber `850/400` — bump if first wave feels unwinnable.  
- Wave jitter ±20–30s is intentional for replayability.  
- Lv5 abilities are the first “fun spike”; test from a loaded Lv5 code.  
- If fortress dies too easily, give it fortified armor via Object Editor later.  
