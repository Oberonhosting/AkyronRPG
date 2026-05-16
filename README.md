# Akyron RPG

> *"O Ciclo se quebrou. As Seis Correntes vazaram para o mundo. Quem
> consegue domar mais de uma, escreve o próximo Éon."*

Akyron RPG é um RPG **mobile + PC** (híbrido) com modo **online e offline**,
inspirado em Black Clover, Bleach, Naruto, Demon Slayer, HxH, Fairy Tail,
MHA e Jujutsu Kaisen — mas com um universo, lore e mitologia próprios.

Construído em **Flutter + Flame**, roda em Android, iOS, Windows, Linux,
macOS e Web a partir do mesmo código.

---

## 🎮 Pilares do design

- **Combate por turnos cinemático** com nomes de habilidades gritados em
  texto estilo mangá e câmera dinâmica nas ultimates.
- **6 sistemas de poder** vivendo no mesmo mundo: Grimórios, Zanpaku-tō,
  Chakra, Respirações, Nen e Energia Amaldiçoada.
- **Sistema de roupas** com cabeça, topo (corsets medievais, casacões,
  kimonos, armaduras), inferior, calçado, manto, acessórios e auras
  visíveis no avatar.
- **Modo Despertar** ativado em HP crítico — transformação visual e novas
  habilidades.
- **Multiplayer híbrido**: jogue 100% offline (SQLite local) ou conecte em
  servidores públicos, privados, lixo/free ou premium aprovados.
- **Eventos de mundo**: bosses globais que reúnem todos os jogadores
  online simultaneamente.
- **Visual pixel-art** com paleta vibrante, magias explodindo sobre
  cenários sombrios, na pegada de Eastward / Chrono Trigger / Coromon mas
  com energia anime.

---

## 🛠️ Tech stack

| Camada            | Tecnologia                                  |
|-------------------|---------------------------------------------|
| UI / app shell    | Flutter (null-safety, Material 3)           |
| Game engine       | Flame 1.x                                   |
| Estado            | flutter_riverpod                            |
| Save local        | sqflite (+ sqflite_common_ffi p/ desktop)   |
| Auth / cloud save | Supabase                                    |
| Multiplayer       | WebSockets (web_socket_channel)             |
| Áudio             | flame_audio                                 |
| Tiles             | flame_tiled                                 |

---

## 📁 Estrutura

```
lib/
├── main.dart
├── akyron_app.dart
├── lore/                  # Códex narrativo, regiões, facções
├── core/                  # Constantes, tema, geração de ID
├── models/                # Personagem, equipamentos, stats, save
├── systems/
│   ├── powers/            # 6 sistemas de poder
│   ├── combat/            # Engine de batalha por turnos
│   ├── progression/       # Rank, level, battle pass
│   └── clothing/          # Catálogo e equipagem
├── data/                  # Repositórios, DB, catálogos
├── game/                  # Componentes Flame, mapa, mundo
├── ui/                    # Telas Material + overlays mangá
├── network/               # Servidores e packets
└── social/                # Amigos, party, guild, chat
```

---

## ▶️ Como rodar

```bash
flutter pub get

# Mobile
flutter run                       # Android/iOS

# PC
flutter run -d windows
flutter run -d linux
flutter run -d macos

# Web
flutter run -d chrome
```

Não precisa de internet para jogar — o modo offline tem campanha completa,
dungeons, missões e progressão. Para jogar online, vá em **Menu → Servidores**.

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

Saiba mais em `lib/lore/world_lore.dart`.

---

## 🚧 Status

Em desenvolvimento ativo. Veja [`docs/ROADMAP.md`](docs/ROADMAP.md).
