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
6. [Login, contas e moeda](#-login-contas-e-moeda)
7. [Economia — lojas, casas, hotéis, marketplace](#-economia)
8. [Como jogar](#-como-jogar)
9. [Controles](#-controles)
10. [Áudio — adicionar trilhas](#-áudio--adicionar-trilhas)
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

## 🔐 Login, contas e moeda

### Login obrigatório

Ao abrir o jogo, você passa pelo **AuthGate**:

- **Primeira vez**: aperte *Criar conta nova* e escolha um nome de
  usuário único + senha. Receberá um **ID público** `#Nome0000` único
  para sempre (usado em convites, party, marketplace).
- **Voltas seguintes**: a sessão fica salva no dispositivo até você
  fazer **logout manual** ou ficar **30 dias sem abrir** o jogo. Quem
  joga regularmente nunca precisa logar de novo.

### Como as contas são guardadas

- Senha armazenada como **SHA-256 + salt aleatório de 16 bytes** —
  ninguém (nem o desenvolvedor) consegue ver sua senha em texto.
- Cada conta vive no **SQLite local** (modo offline) e/ou sincroniza
  com o servidor (modo online via Supabase).
- Username é **case-insensitive** e único globalmente; o `#ID` é
  garantido único por retry de geração.

### Rotação do aparelho (mobile)

Em vez de **forçar** a tela em paisagem, o jogo agora **pede
educadamente**: se você abrir o app em retrato, vai aparecer um overlay
animado "Gire o aparelho". Quando girar, o jogo aparece. PC e Web
ignoram esse gate.

### 💎 Moeda: Lascas de Éon

A moeda do mundo de Akyron são as **Lascas de Éon** (símbolo: `LE`).
Você ganha:

- Vencendo combates (XP + LE).
- Vendendo materiais e drops para NPCs.
- Vendendo no marketplace pra outros jogadores.
- Completando quests e dungeons.

Você gasta em **comida, poções, livros de magia, grimórios, casas,
quartos de hotel** e qualquer coisa no marketplace. Veja a próxima
seção.

---

## 💰 Economia

A economia foi pensada pra ser tão importante quanto o combate. Tudo
em LE. Tudo acessível pelo botão **Cidade** na HUD.

### 🏪 Lojas de NPC (`lib/economy/shop_catalog.dart`)

Cada região tem comerciantes diferentes. Você compra **e vende** pra
eles. A taxa de recompra varia (40–70 % do preço base).

| Região          | Loja                            | Especialidade                  |
|-----------------|---------------------------------|--------------------------------|
| Espinho-de-Estrela | Armazém do Velho Eron        | Comida, poções básicas, ervas  |
| Espinho-de-Estrela | Forja do Punhal Torto        | Materiais e armas iniciais     |
| Torre dos Magos | Biblioteca de Pergaminhos       | Livros que ensinam magias      |
| Torre dos Magos | Casa de Frascos da Iyari        | Poções avançadas e raridades   |
| Floresta Arcana | Pergaminhos da Folha-do-Lago    | Jutsus e pílulas de chakra     |
| Terras Amaldiçoadas | Caixa da Marca Aberta       | Itens amaldiçoados             |
| Torre dos Magos | Leilão de Folhas (anônimo)      | **Grimórios** (3F, 4F, 5F)     |

### 🍞 Itens — comida, poções, livros, grimórios (`item_catalog.dart`)

- **Comidas e poções**: Pão de Cevada, Bolinho do Espírito, Ensopado
  de Corvo, Arroz de Éon, Chá de Mago, Pílula de Chakra, Bala
  Amaldiçoada, Ração de Viagem, Poção de Cura Menor/Maior, Poção de
  Mana, Bálsamo Anti-Queimadura, Antídoto, Elixir do Despertar,
  Tônico do Estudioso (+XP), Tônico do Mercador (+LE).
- **Materiais**: Erva de Estrela, Prata-Luar, Presa de Devorador,
  Essência Amaldiçoada, Seda Arcana, **Estilhaço Bruto de Éon**.
- **Livros**: Tomo da Lança Carmesim, Devorador de Mana, Pergaminho do
  Mil Pássaros, Sexta Forma — Maré que Sobe, Tratado do Flash Negro,
  Manuscrito da Lâmina Espectral. Cada livro **ensina uma habilidade**
  ao ser consumido (exige sistema + level mínimo).
- **Grimórios**: Chama 3F (épico), Véu 4F (lendário), **Iyari 5F
  (transcendente — 38 000 LE)**.

### 🏠 Casas e propriedades (`housing_catalog.dart`)

Você pode comprar imóveis em qualquer região. Cada casa tem **baú
extra**, **fast-travel** (dorme e teleporta de volta) e **features**
especiais (jardim de ervas, oficina, biblioteca, mesa de runas, altar
do espírito, portal de Expansão).

| Casa                              | Região              | Preço      |
|-----------------------------------|---------------------|------------|
| Cabana de Espinho-de-Estrela      | Vila inicial        | 1.500 LE   |
| Sítio da Borda da Floresta        | Vila inicial        | 4.200 LE   |
| Apartamento na Torre              | Velmoria            | 6.800 LE   |
| Cabana da Floresta Karasuho       | Floresta Arcana     | 3.600 LE   |
| Quarto no Dojo de Shirogane       | Plano Espiritual    | 5.400 LE   |
| Casarão do Bairro Antigo          | Velmoria            | 22.000 LE  |
| Santuário Amaldiçoado             | Terras Amaldiçoadas | 48.000 LE  |
| **Espiral de Éon** (endgame)      | Masmorra do Rei     | 250.000 LE |

### 🛏️ Hotéis (`housing_catalog.dart`)

Pra quem ainda não tem casa, hotéis curam você e dão buffs temporários:

- **Pousada Cova da Coruja** (espartano: 40 LE / confortável: 120 LE).
- **Suíte da Torre** (royal: 480 LE — buff Inspirado).
- **Loft do Dojo de Shirogane** (220 LE — buff Espírito-Próximo).
- **Cela do Santuário Amaldiçoado** (360 LE — buff Sintonizado com Éon).

### 💱 Marketplace player ↔ player (`marketplace.dart`)

A **Bolsa de Velmoria** é o marketplace global onde qualquer jogador
posta itens para vender. Taxa fixa de **5 %** vai para a bolsa, o resto
vai pro vendedor.

Como funciona:

1. Abra **Cidade → Bolsa de Velmoria → POSTAR**.
2. Escolha um item do seu inventário, quantidade e preço por unidade
   (o jogo sugere ~20 % acima do preço base do NPC).
3. A oferta dura **7 dias**. Outros jogadores podem comprar tudo ou
   parte. Você recebe a LE menos a taxa.

Modo offline: as ofertas ficam só na sua máquina. Quando você se
conecta a um servidor premium, elas sincronizam pro mercado global.

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

## 🖥️ Servidor e apps — arquitetura

**Você tem dois caminhos** quando for distribuir:

### Opção A — App único (recomendado)

O mesmo projeto Flutter já compila para tudo:

```bash
flutter build apk           # Android
flutter build appbundle     # Play Store
flutter build ios           # iOS (Mac + Xcode)
flutter build windows       # .exe
flutter build linux         # binary
flutter build macos         # .app
flutter build web           # site estático
```

O **app** (Android/iOS) e o **site** (Web) são exatamente o mesmo
código. Não precisa de pasta separada para o app.

### Opção B — Servidor backend (pasta separada)

Para multiplayer **online de verdade** (marketplace global, boss
mundial sincronizado, chat público), você precisa subir o servidor
backend que vive em **`server/`** — projeto **Dart standalone**,
totalmente desacoplado do app.

```bash
cd server
dart pub get
dart run akyron_server:akyron_server --port 28960 --kind premium
```

Compile para um único binário (~10 MB, sem dependência do Dart) para
produção:

```bash
dart compile exe bin/akyron_server.dart -o akyron_server
./akyron_server --port 28960
```

Suporta systemd, Docker e qualquer VPS. Veja **`server/README.md`**
para deploy completo (systemd unit, Dockerfile pronto).

**Sem o servidor**: tudo funciona offline, marketplace local, save
em SQLite. Você só perde multiplayer global.

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
