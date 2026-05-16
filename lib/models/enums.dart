// Enums compartilhados pelo jogo inteiro.

/// Gênero do avatar — afeta sprites e silhuetas. Cada gênero tem visuais
/// totalmente distintos mas igualmente estilizados.
enum Gender { masculine, feminine }

/// Sistema de poder escolhido na criação.
enum PowerSystem {
  grimoire,    // Mago de Grimório (Black Clover)
  zanpakuto,   // Espadachim Espiritual (Bleach)
  chakra,      // Ninja de Chakra (Naruto)
  breathing,   // Caçador de Demônios (Demon Slayer)
  nen,         // Usuário de Nen (HxH)
  cursed,      // Feiticeiro Amaldiçoado (JJK)
}

extension PowerSystemX on PowerSystem {
  String get displayName => switch (this) {
        PowerSystem.grimoire => 'Mago de Grimório',
        PowerSystem.zanpakuto => 'Espadachim Espiritual',
        PowerSystem.chakra => 'Ninja de Chakra',
        PowerSystem.breathing => 'Caçador de Demônios',
        PowerSystem.nen => 'Usuário de Nen',
        PowerSystem.cursed => 'Feiticeiro Amaldiçoado',
      };

  String get auraKey => switch (this) {
        PowerSystem.grimoire => 'grimoire',
        PowerSystem.zanpakuto => 'zanpakuto',
        PowerSystem.chakra => 'chakra',
        PowerSystem.breathing => 'breathing',
        PowerSystem.nen => 'nen',
        PowerSystem.cursed => 'cursed',
      };
}

/// Elementos elementais — alguns sistemas só usam um subconjunto.
enum Element {
  fire, water, earth, wind, lightning, ice, light, dark,
  time, space, life, chaos, blood, sound, gravity,
}

/// Raridade compartilhada para itens, magias e grimórios.
enum Rarity { common, rare, epic, legendary, transcendent }

extension RarityX on Rarity {
  String get label => switch (this) {
        Rarity.common => 'Comum',
        Rarity.rare => 'Raro',
        Rarity.epic => 'Épico',
        Rarity.legendary => 'Lendário',
        Rarity.transcendent => 'Transcendente',
      };
}

/// Rank do personagem.
enum Rank { d, c, b, a, s, ss, legendary, transcendent }

extension RankX on Rank {
  String get label => switch (this) {
        Rank.d => 'D',
        Rank.c => 'C',
        Rank.b => 'B',
        Rank.a => 'A',
        Rank.s => 'S',
        Rank.ss => 'SS',
        Rank.legendary => 'Lendário',
        Rank.transcendent => 'Transcendente',
      };
}

/// Slots de equipamento.
enum EquipSlot { head, top, bottom, footwear, cloak, accessory, aura, weapon }

extension EquipSlotX on EquipSlot {
  String get label => switch (this) {
        EquipSlot.head => 'Cabeça',
        EquipSlot.top => 'Topo',
        EquipSlot.bottom => 'Inferior',
        EquipSlot.footwear => 'Calçado',
        EquipSlot.cloak => 'Manto',
        EquipSlot.accessory => 'Acessório',
        EquipSlot.aura => 'Aura',
        EquipSlot.weapon => 'Arma',
      };
}

/// Status que podem afetar combatentes.
enum StatusEffect {
  burn, paralysis, curse, freeze, poison, bleed,
  silence, stun, haste, regen, shield, awakened,
}

/// Tipo de Nen (HxH-inspired).
enum NenType {
  enhancement, emission, manipulation, materialization, transmutation, conjuration,
}

extension NenTypeX on NenType {
  String get label => switch (this) {
        NenType.enhancement => 'Reforço',
        NenType.emission => 'Emissão',
        NenType.manipulation => 'Manipulação',
        NenType.materialization => 'Materialização',
        NenType.transmutation => 'Transmutação',
        NenType.conjuration => 'Conjuração',
      };
}

/// Tipos de servidor multiplayer.
enum ServerKind {
  offline,      // Modo solo, sem rede.
  publicWorld,  // Mundo compartilhado oficial.
  privateRoom,  // Sala com senha criada por jogador.
  freeJunk,     // Servidores "lixo/free" — rápidos, sem garantia.
  premiumApproved, // Estáveis, moderados, competitivos.
}

extension ServerKindX on ServerKind {
  String get label => switch (this) {
        ServerKind.offline => 'Offline',
        ServerKind.publicWorld => 'Mundo Público',
        ServerKind.privateRoom => 'Sala Privada',
        ServerKind.freeJunk => 'Servidor Livre',
        ServerKind.premiumApproved => 'Servidor Premium',
      };
}
