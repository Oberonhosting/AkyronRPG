# Akyron RPG — Roadmap

## ✅ Sprint 0 — Fundação
- [x] Estrutura de pastas + pubspec
- [x] Lore do universo (Fratura do Éon, 6 nações, 6 correntes)
- [x] Modelos: Character, Appearance, Stats, Equipment, SaveData
- [x] 6 sistemas de poder (Grimório, Zanpakutō, Chakra, Respirações, Nen, Energia Amaldiçoada)
- [x] Catálogos iniciais de habilidades por sistema
- [x] Engine de combate por turnos com despertar, status, combos, ultimate
- [x] Sistema de roupas (cabeça, topo, inferior, calçado, manto, acessório, aura)
- [x] Save local SQLite + cloud sync esqueleto
- [x] Componentes Flame: player, mundo top-down, clima, boss mundial
- [x] UI: splash, menu, criação de personagem, exploração, combate
- [x] Rede: ServerManager (offline/público/privado/lixo/premium)
- [x] Social: amigos por ID, party, guild, chat

## ✅ Sprint 0.5 — Áudio adaptativo
- [x] AudioDirector com mood (região/HP/clima/combate/ultimate)
- [x] 22 trilhas catalogadas com BPM e direção artística
- [x] 30+ SFX (UI, magias, espadas, status, world boss, ambientes)
- [x] Tela de Áudio com sliders e prévia de mood
- [x] Fallback silencioso quando arquivo faltar

## ✅ Sprint 1 — Conta + economia
- [x] Login + Registro com SHA-256 + salt
- [x] Sessão persistente 30 dias
- [x] AuthGate antes do menu
- [x] Rotação **pedida** em vez de forçada (mobile)
- [x] Moeda Lascas de Éon (LE) com formatação pt-BR
- [x] Catálogo de comida (8 pratos + 8 poções)
- [x] Catálogo de materiais (6 categorias)
- [x] Catálogo de livros que ensinam magias (6 tomes)
- [x] Catálogo de grimórios à venda (1F a 5F)
- [x] Catálogo de casas (8 imóveis em 6 regiões)
- [x] Catálogo de hotéis (5 tipos de quarto)
- [x] Marketplace player ↔ player com taxa de 5%
- [x] 7 lojas de NPC distribuídas por região
- [x] Telas: City Hub, Shop, Marketplace, Housing
- [x] Servidor Dart standalone (HTTP + WebSocket) em `server/`

## 🔜 Sprint 2 — Conteúdo
- [ ] 12 grimórios canônicos com magias completas
- [ ] 10 zanpaku-tō com cutscenes de Bankai
- [ ] 30+ jutsus por elemento de chakra
- [ ] 7 estilos de respiração com 10+ formas cada
- [ ] Construtor visual de habilidade Nen
- [ ] 6 técnicas inatas amaldiçoadas com Expansões de Território
- [ ] 80+ peças de roupa com pixel art próprio

## 🔜 Sprint 3 — Mundo
- [ ] Tilemaps Tiled para 6 regiões
- [ ] Sistema de eventos meteorológicos animados
- [ ] Boss mundial sincronizado com timer global
- [ ] Fast travel via Portais Aetéricos
- [ ] Sistema de craft no workshop das casas

## 🔜 Sprint 4 — Online robusto
- [ ] Integração Supabase real (auth + cloud save)
- [ ] Anti-cheat com checksum de save server-side
- [ ] Matchmaking ranqueado por liga
- [ ] Replay system de batalhas
- [ ] Eventos sazonais com battle pass
- [ ] Marketplace global via servidor (HTTP `/market/listings`)

## 🔜 Sprint 5 — Polimento
- [ ] Pixel art profissional substituindo placeholders
- [ ] Trilha sonora original por região
- [ ] Tutorial cinemático
- [ ] Localizações (PT-BR, EN, JP)
- [ ] Build CI/CD para todas as plataformas
