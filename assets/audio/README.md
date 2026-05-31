# Akyron RPG — Specs de Áudio

Esta pasta deve conter **arquivos `.ogg`** (44.1 kHz, mono ou stereo,
~128 kbps). O jogo já está integrado: caso o arquivo não exista, o
`AudioDirector` falha em silêncio e o jogo continua sem som.

A lista canônica de arquivos vive em `lib/audio/track_catalog.dart`.
Os caminhos abaixo são relativos a `assets/audio/`.

---

## 🎼 `music/` — Trilhas (loop ou stinger)

| Arquivo                    | Mood                | Duração ideal | Direção                                                    |
|----------------------------|---------------------|---------------|------------------------------------------------------------|
| `01_akyron_logo.ogg`       | splash              | 4 s, no loop  | Sino solene, naipe de cordas seguram a respiração.         |
| `02_menu_eon.ogg`          | mainMenu            | 2 min, loop   | Piano em loop sobre pad arcano. Convida e ameaça.          |
| `03_chapter_sting.ogg`     | chapterIntro        | 2.5 s, no loop| Acento metálico + taiko duplo + coro grave.                |
| `10_village_starthorn.ogg` | exploreVillage      | 90 s, loop    | Acústico leve, flauta + bandolim, sensação de "casa".      |
| `11_forest_arcane.ogg`     | exploreForest       | 90 s, loop    | Pad de sintetizador antigo + percussão tribal lenta.       |
| `12_mage_tower.ogg`        | exploreTower        | 90 s, loop    | Cravo dissonante, sinos invertidos, suspense vertical.     |
| `13_spirit_plane.ogg`      | exploreSpirit       | 120 s, loop   | Coros femininos etéreos, vento e vidro.                    |
| `14_cursed_lands.ogg`      | exploreCursed       | 90 s, loop    | Baixo distorcido, sopros graves, lamento ao fundo.         |
| `15_demon_keep.ogg`        | exploreDemon        | 90 s, loop    | Metal sinfônico, taiko pesado, coro masculino.             |
| `20_suspense_pulse.ogg`    | suspense            | 60 s, loop    | Pulso de baixo + corda aguda em harmônico.                 |
| `30_combat_standard.ogg`   | combatRegular       | 100 s, loop   | Guitarra elétrica + violino, batida shōnen.                |
| `31_combat_boss.ogg`       | combatBoss          | 120 s, loop   | Coro latino sobre orquestra agressiva.                     |
| `32_world_boss.ogg`        | combatWorldBoss     | 150 s, loop   | Tema épico — todos os jogadores ouvem o mesmo loop.        |
| `40_ultimate_swell.ogg`    | ultimate            | 3 s, no loop  | Stinger para cobrir o grito da ultimate.                   |
| `50_victory_fanfare.ogg`   | victory             | 6 s, no loop  | Metais brilhantes em fanfarra.                             |
| `51_defeat_lament.ogg`     | defeat              | 5 s, no loop  | Piano só, frase descendente.                               |
| `60_shikai_release.ogg`    | cutsceneShikai      | 5 s, no loop  | Coro ascendente + acorde sustentado.                       |
| `61_bankai_release.ogg`    | cutsceneBankai      | 7 s, no loop  | Trovão + sino quebrado + coro grave.                       |
| `62_domain_expansion.ogg`  | cutsceneDomain      | 6.5 s, no loop| Tudo silencia, então um acorde sufoca a arena.             |
| `70_awakening.ogg`         | awakening           | 4 s, no loop  | Coração batendo + corda subindo + flash de metal.          |
| `80_guild_hall.ogg`        | guildHall           | 90 s, loop    | Tema acolhedor com mandolina e percussão suave.            |
| `81_pass_reveal.ogg`       | battlePassReveal    | 3.5 s, no loop| Stinger curto, brilhante, com glitter sintético.           |

---

## 💥 `sfx/` — Efeitos one-shot

Curtos (< 1.5 s), normalizados a -3 dB.

- `ui_click.ogg`, `ui_back.ogg`, `ui_hover.ogg`
- `level_up.ogg`, `unlock_skill.ogg`
- `equip.ogg`, `unequip.ogg`
- `coin.ogg`, `item_drop.ogg`, `door_open.ogg`
- `spell_low.ogg`, `spell_mid.ogg`, `spell_high.ogg`
- `sword_slash.ogg`, `sword_parry.ogg`
- `punch_hit.ogg`, `enemy_hit.ogg`, `crit_hit.ogg`, `enemy_die.ogg`
- `shield_block.ogg`
- `burn_tick.ogg`, `poison_tick.ogg`, `freeze_apply.ogg`, `cursed_hum.ogg`
- `awakening_flash.ogg`
- `party_invite.ogg`, `chat_ping.ogg`
- `world_boss_roar.ogg`

---

## 🌬️ `ambient/` — Camadas ambientais (looping baixo)

- `bird.ogg`, `fire_crackle.ogg`, `wind_high.ogg`, `cave_drip.ogg`
- `rain.ogg`, `thunder.ogg`

---

## 📝 Onde conseguir áudio

Para preencher rapidamente com som temporário:

- **OpenGameArt.org** — milhares de tracks CC0
- **Freesound.org** — SFX, sempre verifique licença
- **Pixabay** — música royalty-free
- **Itch.io** — buscar "free music pack rpg"

Convencione no nome do arquivo: nada precisa mudar no código se você
apenas substituir o conteúdo das `.ogg` mantendo o mesmo nome.
