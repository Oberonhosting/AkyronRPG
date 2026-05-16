# Akyron RPG

> *"O Ciclo se quebrou. As Seis Correntes vazaram para o mundo. Quem
> consegue domar mais de uma, escreve o próximo Éon."*

Akyron RPG é um RPG **mobile + PC** (híbrido) com modo **online e offline**,
inspirado em Black Clover, Bleach, Naruto, Demon Slayer, HxH, Fairy Tail,
MHA e Jujutsu Kaisen — mas com universo, lore, geografia e mitologia
próprios.

Construído em **Flutter + Flame**, roda em **Android, iOS, Windows, Linux,
macOS e Web** a partir do mesmo código.

---

## 📑 Sumário

1. [Pilares do design](#-pilares-do-design)
2. [Tech stack](#-tech-stack)
3. [Estrutura do projeto](#-estrutura-do-projeto)
4. [Instalando o ambiente](#-instalando-o-ambiente)
5. [Como rodar (por plataforma)](#-como-rodar-por-plataforma)
6. [Como jogar](#-como-jogar)
7. [Controles](#-controles)
8. [Áudio — adicionar trilhas](#-áudio--adicionar-trilhas)
9. [Online vs Offline](#-online-vs-offline)
10. [Build de produção](#-build-de-produção)
11. [Troubleshooting](#-troubleshooting)
12. [Lore](#-universo-resumo)
13. [Roadmap](#-roadmap)

---

## 🎮 Pilares do design

- **Combate por turnos cinemático** com nomes de habilidades gritados em
  letras gigantes estilo mangá e câmera dinâmica nas ultimates.
- **6 sistemas de poder** vivendo no mesmo mundo: Grimórios, Zanpaku-tō,
  Chakra, Respirações, Nen e Energia Amaldiçoada.
- **Sistema de roupas** com cabeça, topo (corsets medievais, casacões,
  kimonos, armaduras), inferior, calçado, manto, acessórios e aura —
  todos visíveis no avatar.
- **Modo Despertar** ativado em HP crítico — transformação visual + buff.
- **Trilha sonora adaptativa**: a música muda sozinha com a região, o
  clima, a HP do jogador, o tipo de combate e cobre as ultimates com
  stingers cinemáticos. Configurável em **Menu → Áudio**.
- **Multiplayer híbrido**: jogue 100 % offline (SQLite local) ou conecte
  em servidores **público / privado com senha / free / premium aprovado**.
- **Eventos de mundo**: bosses globais que reúnem todos os jogadores
  online no mesmo combate.
- **Pixel-art** com paleta vibrante, magias explodindo sobre cenários
  sombrios — pegada de Eastward / Chrono Trigger / Coromon com energia
  anime.

---

## 🛠️ Tech stack

| Camada            | Tecnologia                                  |
|-------------------|---------------------------------------------|
| UI / app shell    | Flutter (null-safety, Material 3)           |
| Game engine       | Flame 1.x                                   |
| Áudio             | flame_audio (bgm + sfx + crossfade)         |
| Estado            | flutter_riverpod                            |
| Save local        | sqflite (+ sqflite_common_ffi p/ desktop)   |
| Auth / cloud save | Supabase                                    |
| Multiplayer       | WebSockets (web_socket_channel)             |
| Tiles             | flame_tiled                                 |

---

## 📁 Estrutura do projeto

```
lib/
├── main.dart                 # entrypoint: init Flutter + AudioDirector
├── akyron_app.dart           # MaterialApp + rotas
├── lore/                     # Códex narrativo (Fratura do Éon, 6 nações)
├── core/                     # Constantes, tema, geração de #ID
├── audio/
│   ├── audio_director.dart   # Orquestra música por mood
│   └── track_catalog.dart    # Catálogo de tracks + SFX
├── models/                   # Personagem, equipamentos, stats, save
├── systems/
│   ├── powers/               # 6 sistemas de poder
│   ├── combat/               # Engine de batalha por turnos
│   ├── progression/          # Level, rank, battle pass
│   └── clothing/             # Equipagem / wardrobe
├── data/                     # SQLite, cloud sync, catálogos
├── game/                     # Componentes Flame, mapa, mundo, clima
├── ui/
│   ├── screens/              # Splash, menu, criação, exploração, combate, equipar, códex, áudio
│   └── widgets/              # Manga dialog, stat bar, level-up, chapter intro, battle cry
├── network/                  # Servidores, packets, anti-cheat
└── social/                   # Amigos, party, guild, chat
assets/
├── images/                   # Sprites (placeholder)
└── audio/                    # Trilha + SFX (ver assets/audio/README.md)
```

---

## ⚙️ Instalando o ambiente

### 1. Instale o Flutter

Siga o guia oficial em **https://docs.flutter.dev/get-started/install** e
escolha a sua plataforma:

| Sistema   | Caminho rápido                                                   |
|-----------|------------------------------------------------------------------|
| Windows   | Baixe o ZIP e adicione `flutter\bin` ao PATH                     |
| macOS     | `brew install --cask flutter` (Homebrew)                         |
| Linux     | `sudo snap install flutter --classic` ou baixe o tarball         |

Após instalar, valide com:

```bash
flutter --version       # precisa ser Flutter 3.22 ou maior
flutter doctor          # corrija o que ele apontar
```

### 2. Habilite as plataformas alvo

```bash
# PC (escolha as que vai usar)
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
flutter config --enable-web
```

### 3. Clone e instale dependências

```bash
git clone https://github.com/Oberonhosting/AkyronRPG.git
cd AkyronRPG
flutter pub get
```

> ⚠️ Se aparecer erro do tipo "no version solving for sqflite_common_ffi"
> rode `flutter clean && flutter pub get`.

### 4. (Opcional) Crie os scaffolds de cada plataforma

Por padrão o projeto vem com `lib/` mas pode ainda **não** ter as pastas
nativas (`android/`, `ios/`, `windows/`, etc.) se foi clonado limpo.
Rode uma vez:

```bash
flutter create . \
  --project-name akyron_rpg \
  --org com.akyron \
  --platforms android,ios,windows,linux,macos,web
```

Isso só adiciona as pastas nativas — **não** sobrescreve o seu `lib/`.

---

## ▶️ Como rodar (por plataforma)

Liste dispositivos disponíveis:

```bash
flutter devices
```

### Mobile

```bash
# Android (emulador ou device USB)
flutter run -d android

# iOS (Mac + Xcode, simulador ou device)
flutter run -d ios
```

### PC

```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

### Web

```bash
flutter run -d chrome
# ou outro browser registrado
```

### Modo dev rápido

Durante uma sessão `flutter run`:

- `r` — hot reload
- `R` — hot restart
- `o` — alterna platform-overrides
- `q` — sai

---

## 🎮 Como jogar

1. **Inicie o app** — vai aparecer a logo do Akyron e a tela de menu
   principal. A trilha **Menu — Éon Adormecido** começa a tocar.
2. **Toque em "Nova Jornada"** e crie seu personagem:
   - Escolha gênero (masculino/feminino com visuais distintos).
   - Customize cabelo, olhos, tom de pele, altura, build.
   - Escolha sua **classe inicial** entre as 6 (cada uma usa um sistema
     de poder diferente).
   - Escolha o elemento/afinidade.
   - Aperte **Despertar Personagem** — o jogo gera seu `#ID` (`#Yami4521`).
3. **Explore** a Vila de Espinho-de-Estrela e a Floresta Arcana.
4. Botão **Treino** abre um combate por turnos contra a Sombra de Treino:
   - Escolha uma habilidade — o nome aparece gigante na tela e a música
     muda para o stinger apropriado.
   - Ao chegar a 25 % de HP, você **desperta** automaticamente.
   - Ultimates disparam cutscenes sonoras (Bankai, Expansão de Território
     ou Ultimate genérica).
5. Botão **Equipar** abre o guarda-roupa: troque corsets, casacões,
   kimonos, armaduras, mantos, acessórios e auras.
6. Botão **Códex** abre o livro de lore do mundo.
7. No menu principal, **Servidores Online** lista os servidores
   disponíveis (offline, públicos, privados, free e premium aprovados).

---

## 🎛️ Controles

### PC (teclado/mouse)

| Ação          | Tecla                       |
|---------------|-----------------------------|
| Mover         | `W A S D` ou setas          |
| Interagir     | clique do mouse / `E`       |
| Hot-reload    | `r` no terminal do `flutter run` |

### Mobile (touch)

- **Joystick virtual** no canto inferior esquerdo para movimentação.
- Toque nos botões da HUD: **Equipar / Treino / Códex**.
- Toque nas habilidades no combate.

---

## 🎵 Áudio — adicionar trilhas

O jogo já está **completamente integrado** com música adaptativa. O que
você precisa é colocar os arquivos `.ogg` na pasta correta:

```
assets/audio/
├── music/      # 22 tracks (loops e stingers)
├── sfx/        # ~30 efeitos one-shot
└── ambient/    # 6 camadas ambientais
```

**Veja `assets/audio/README.md`** — ele lista cada arquivo esperado, sua
duração ideal, BPM e a direção artística.

### Comportamento

- A música muda **automaticamente** quando você troca de região, quando
  a HP cai abaixo de 18 % (suspense), quando o clima vira `eclipse` ou
  `blood_rain`, e quando entra/sai de combate.
- **Ultimates** disparam um stinger cinemático (Bankai → tema
  `cutsceneBankai`, Expansão de Território → `cutsceneDomain`, demais →
  `ultimate`) e depois a música volta sozinha.
- **Despertar em HP crítico** dispara o tema `awakening`.
- Vitória/derrota disparam fanfarra/lamento.

### Personalizando

- Cada som pode ser substituído mantendo o nome do arquivo.
- Volume, mood ativo e prévia de todos os tracks ficam em
  **Menu → Áudio**.
- Falha em silêncio: se um arquivo faltar, o jogo segue sem som —
  você verá apenas um log `[AudioDirector] audio op failed`.

### Onde achar música royalty-free

- [OpenGameArt.org](https://opengameart.org/)
- [Freesound.org](https://freesound.org/)
- [Pixabay Music](https://pixabay.com/music/)
- Itch.io — buscar "free music pack rpg"

---

## 🌐 Online vs Offline

### Modo offline (padrão)

- Jogo completo **sem nenhuma conexão**.
- Save em **SQLite local** (`~/Documents/akyron_save.db` em mobile,
  `%APPDATA%/akyron_rpg/` em Windows, etc.).
- Campanha principal, dungeons, missões e progressão funcionam 100 %.

### Modo online

Acesse em **Menu → Servidores Online**. Quatro tipos:

| Tipo                  | Quando usar                                                 |
|-----------------------|-------------------------------------------------------------|
| 🌐 **Público**        | Mundo compartilhado oficial — bosses globais, eventos PvE.  |
| 🔒 **Privado**        | Sala criada por jogador, com senha — clã/amigos.            |
| 💨 **Free/Lixo**      | Servidores rápidos sem garantia — casual.                   |
| ⭐ **Premium aprovado**| Estáveis, com moderação e anti-cheat — competitivo.        |

**Anti-cheat** roda apenas nos premium aprovados (checksum de save +
sanity check de stats por level).

**Sincronização**: ao conectar, o save local é comparado com o save
na nuvem (Supabase). Vence o mais novo. Para isso funcionar de verdade,
configure as variáveis em `lib/data/cloud_sync.dart` com seu projeto
Supabase.

---

## 📦 Build de produção

### APK Android

```bash
flutter build apk --release
# saída: build/app/outputs/flutter-apk/app-release.apk
```

### App bundle (Play Store)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
# abra Runner.xcworkspace no Xcode para assinar e fazer upload.
```

### Windows

```bash
flutter build windows --release
# saída: build/windows/runner/Release/
```

### Linux

```bash
flutter build linux --release
# saída: build/linux/x64/release/bundle/
```

### macOS

```bash
flutter build macos --release
```

### Web

```bash
flutter build web --release
# saída: build/web/  — sirva com qualquer static host
```

---

## 🧪 Testes

```bash
flutter test
```

Cobertura básica de geração de ID, catálogos e sistema de Grimório.

---

## 🛠️ Troubleshooting

| Sintoma                                                | Solução                                                                                  |
|--------------------------------------------------------|------------------------------------------------------------------------------------------|
| `Unable to find git` no `flutter pub get`              | Instale o Git e adicione ao PATH.                                                        |
| Áudio não toca                                         | Verifique se os `.ogg` estão em `assets/audio/`. O director falha silenciosamente.       |
| `sqflite` lança "MissingPluginException" no desktop    | Já está resolvido via `sqflite_common_ffi`. Faça `flutter clean && flutter pub get`.     |
| Web não carrega CanvasKit                              | Use `--web-renderer canvaskit` ou faça build com `--release`.                            |
| Joystick não aparece no mobile                         | O joystick só aparece em Android/iOS. Para forçar no desktop, edite `_isMobile`.         |
| Erro "Permission denied" salvando no Linux             | Cheque permissões de `~/.local/share/akyron_rpg/`.                                       |
| Save corrompido                                        | Delete o arquivo do diretório de aplicação — o jogo recria.                              |

---

## 🌍 Universo (resumo)

O continente de **Akyron** é o que sobrou depois da **Fratura do Éon** —
quando o Ciclo de poder do mundo se quebrou e seis correntes de energia
distintas vazaram para a realidade. Hoje, cada nação domina (ou tenta
domar) uma das correntes:

- **Velmoria** — grimórios e magia escrita
- **Shirogane** — espíritos de aço (zanpaku-tō)
- **Konsho** — vilas ninja de chakra
- **Karasuho** — respirações elementais que caçam os Devoradores
- **Yorokai** — auras de Nen e mestres-tutores
- **Sukhenna** — feiticeiros que dobram a energia amaldiçoada

E rumores falam de **Transcendentes** que dominam **duas** correntes ao
mesmo tempo. Apenas três foram registrados. Quem termina o post-game
pode, talvez, virar o quarto.

Tudo isso é navegável em **Menu → Códex do Mundo** ou em
`lib/lore/world_lore.dart`.

---

## 🚧 Roadmap

Veja [`docs/ROADMAP.md`](docs/ROADMAP.md). Próximas frentes:

- **Sprint 1** — conteúdo: 12 grimórios, 10 zanpaku-tōs com Bankai, 30+
  jutsus, 7 estilos de respiração, construtor de habilidade Nen, 6
  técnicas amaldiçoadas com Expansões, 80+ peças de roupa.
- **Sprint 2** — mundo: tilemaps Tiled reais para 6 regiões, eventos
  meteorológicos animados, boss mundial com timer global.
- **Sprint 3** — online robusto: anti-cheat completo, matchmaking
  ranqueado, replay de batalhas, eventos sazonais.
- **Sprint 4** — polimento: pixel-art profissional, trilha sonora
  original por região, tutorial cinemático, localização EN/JP.

---

## 📜 Licença

Projeto pessoal — defina sua licença em `LICENSE`.
