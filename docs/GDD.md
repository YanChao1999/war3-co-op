# Warcraft III: Co-op Commanders — Game Design Document (MVP)

## Fantasy

Two players cooperate as asymmetric **commanders** against scripted Scourge attacks. Keep Warcraft III RTS fundamentals (gold/lumber, bases, armies) while borrowing StarCraft II Co-op’s commander identity, objective missions, and progression.

## MVP product

| Item | Choice |
|------|--------|
| Engine | Classic / The Frozen Throne (`.w3x`, JASS via Wurst) |
| Mission | **The Last Fortress** (~25 minutes) |
| Commanders | **Arthas** (Scourge) and **Thrall** (Horde) |
| Players | 2 allied humans (unique commanders required) |
| Progression | XP + unlocks via **save codes** |
| Distribution | Custom multiplayer map |

## Loop

1. Optional `-load W3C-...` for progression  
2. Each player `-pick arthas` or `-pick thrall`  
3. Build economy, armies, and complete objectives  
4. Survive waves; optionally destroy outposts; face the final Lich  
5. Receive XP and a new save code  

## How it differs from melee

- Commander-specific heroes, armies, and secondary resources  
- Scripted enemy director (not free melee AI)  
- Objective victory (timer / boss), not only base annihilation  
- Persistent commander levels between sessions (save codes)  

## Non-goals (MVP)

Tyrande/Jaina, mutators, extra missions, prestige, Reforged Lua, external accounts.

## Success gate

Two players can finish one run, and the loop stays fun across ~10 replays with wave timing/composition variance.
