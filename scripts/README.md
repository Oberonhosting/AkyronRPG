# Scripts

## 🎵 `generate_audio.sh` — Gera todos os áudios placeholder

Gera os **58 arquivos `.ogg`** esperados pelo jogo via síntese
procedural com `ffmpeg`. **Não é trilha composta** — são acordes,
sweeps, percussão e noise filtrados — mas dá ao jogo áudio funcional
em todos os momentos enquanto você não tem músicas reais.

### Requisito

`ffmpeg` instalado e no PATH.

```bash
# Linux
sudo apt install ffmpeg

# macOS
brew install ffmpeg

# Windows
choco install ffmpeg
# ou baixe em https://ffmpeg.org/download.html
```

### Uso

```bash
# Tudo de uma vez (22 músicas + 30 SFX + 6 ambientes)
bash scripts/generate_audio.sh

# Só uma categoria
bash scripts/generate_audio.sh --only music
bash scripts/generate_audio.sh --only sfx
bash scripts/generate_audio.sh --only ambient

# Sobrescreve arquivos existentes
bash scripts/generate_audio.sh --force
```

Saída: `assets/audio/{music,sfx,ambient}/*.ogg` (já apontados pelo
`pubspec.yaml`).

### Windows sem WSL

`generate_audio.ps1` cobre o subset essencial (splash, menu, UI click,
level up). Para o catálogo completo no Windows, use **WSL** ou
**Git Bash** e rode o `.sh` normal:

```powershell
# Subset rápido nativo
powershell -ExecutionPolicy Bypass -File scripts\generate_audio.ps1

# Catálogo completo (Git Bash / WSL)
bash scripts/generate_audio.sh
```

### Como o som é construído

| Tipo            | Técnica de síntese                                  |
|-----------------|-----------------------------------------------------|
| Música pad      | 3-4 sines em acorde + tremolo + reverb (`aecho`)    |
| Stinger rising  | `aevalsrc=sin(2*PI*t*(f0+(f1-f0)*t/dur))` (sweep)   |
| Suspense pulse  | sine grave + tremolo no BPM da cena                 |
| Combate uptempo | sine modulado por tremolo a 140-160 BPM             |
| Ambientes       | `anoisesrc` filtrado (lowpass/highpass)             |
| Hits / clicks   | burst curto de noise + tom                          |
| Trovão          | brown noise + lowpass + reverb longo                |
| Sinos           | acordes harmônicos com decay                        |

Cada música/SFX tem volume calibrado (música -10 a -18 dB, SFX -4 a
-14 dB) para o mix ficar confortável.

### Substituindo por áudio real

Quando quiser trocar por uma faixa profissional, **mantenha o mesmo
nome de arquivo**. Por exemplo, baixe uma trilha de combate épica e
salve como `assets/audio/music/30_combat_standard.ogg`. Nada no código
muda — o `AudioDirector` já sabe usar.

A lista canônica de arquivos esperados está em
[`assets/audio/README.md`](../assets/audio/README.md), com BPM ideal,
duração e direção musical de cada faixa.

### Onde achar áudio real grátis (CC0 / royalty-free)

- [OpenGameArt.org](https://opengameart.org) — busque "rpg music pack",
  "anime battle music", "epic orchestral cc0"
- [Pixabay Music](https://pixabay.com/music/) — instrumentais grátis
- [Freesound.org](https://freesound.org) — SFX (verifique a licença)
- [Itch.io free music tag](https://itch.io/game-assets/free/tag-music)
- [Kevin MacLeod — incompetech.com](https://incompetech.com) — atribuição

Coloque os arquivos baixados em `assets/audio/{music,sfx,ambient}/` com
o nome canônico (ex.: renomeie para `30_combat_standard.ogg`).
