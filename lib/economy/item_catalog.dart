import '../models/enums.dart';
import 'economy_models.dart';

/// Catálogo central de itens NÃO-vestíveis (consumíveis, materiais,
/// livros e grimórios). Roupas vivem em `clothing_catalog.dart`.
class ItemCatalog {
  ItemCatalog._();

  static final Map<String, GameItem> _index = {
    for (final i in _all) i.id: i,
  };

  static GameItem? byId(String id) => _index[id];
  static Iterable<GameItem> all() => _all;
  static Iterable<T> byType<T extends GameItem>() => _all.whereType<T>();
  static Iterable<GameItem> byCategory(String cat) =>
      _all.where((i) => i.category == cat);

  // ───────────────────────── 🍞 COMIDAS ─────────────────────────
  static const List<ConsumableItem> _foods = [
    ConsumableItem(
      id: 'food.barley_bread',
      name: 'Pão de Cevada',
      description: 'Pão denso de Espinho-de-Estrela. Recupera 30 HP.',
      rarity: Rarity.common,
      basePrice: 8,
      iconAsset: 'assets/images/items/food_bread.png',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: 30)],
      flavor: 'O padeiro grita o nome de cada cliente quando o forno abre.',
    ),
    ConsumableItem(
      id: 'food.spirit_dumpling',
      name: 'Bolinho do Espírito',
      description: 'Massa recheada com erva azulada. +60 HP e +30 MP.',
      rarity: Rarity.rare,
      basePrice: 35,
      iconAsset: 'assets/images/items/food_dumpling.png',
      effects: [
        ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: 60),
        ConsumableEffect(kind: ConsumableEffectKind.healMp, amount: 30),
      ],
      flavor: 'Dizem que o vapor é parte do espírito que se cozinhou junto.',
    ),
    ConsumableItem(
      id: 'food.crow_stew',
      name: 'Ensopado de Corvo',
      description: 'Receita dos caçadores de Karasuho. +120 HP, +20 ataque por 3 turnos.',
      rarity: Rarity.rare,
      basePrice: 75,
      iconAsset: 'assets/images/items/food_stew.png',
      effects: [
        ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: 120),
        ConsumableEffect(kind: ConsumableEffectKind.buffAttack, amount: 20, durationTurns: 3),
      ],
    ),
    ConsumableItem(
      id: 'food.eon_rice',
      name: 'Arroz de Éon',
      description: 'Grão dourado raríssimo. Recupera 100% de tudo.',
      rarity: Rarity.legendary,
      basePrice: 1200,
      iconAsset: 'assets/images/items/food_rice.png',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.fullHeal)],
      flavor: 'Cada grão pulsa fraco no escuro.',
    ),
    ConsumableItem(
      id: 'food.mage_tea',
      name: 'Chá de Mago',
      description: 'Folhas roxas em infusão. +80 MP.',
      rarity: Rarity.common,
      basePrice: 18,
      iconAsset: 'assets/images/items/food_tea.png',
      subcategory: 'tea',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.healMp, amount: 80)],
    ),
    ConsumableItem(
      id: 'food.chakra_pill',
      name: 'Pílula de Chakra',
      description: 'Pequena pílula militar. +100 Chakra mas perde 10 HP.',
      rarity: Rarity.rare,
      basePrice: 90,
      iconAsset: 'assets/images/items/food_pill.png',
      subcategory: 'pill',
      effects: [
        ConsumableEffect(kind: ConsumableEffectKind.healChakra, amount: 100),
        ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: -10),
      ],
    ),
    ConsumableItem(
      id: 'food.cursed_candy',
      name: 'Bala Amaldiçoada',
      description: 'Granulada e amarga. +50 CE.',
      rarity: Rarity.rare,
      basePrice: 65,
      iconAsset: 'assets/images/items/food_candy.png',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.healCursed, amount: 50)],
    ),
    ConsumableItem(
      id: 'food.travel_ration',
      name: 'Ração de Viagem',
      description: 'Kit do aventureiro. +60 HP, +30 MP, fora de combate.',
      rarity: Rarity.common,
      basePrice: 25,
      iconAsset: 'assets/images/items/food_ration.png',
      subcategory: 'rationKit',
      effects: [
        ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: 60),
        ConsumableEffect(kind: ConsumableEffectKind.healMp, amount: 30),
      ],
    ),
  ];

  // ───────────────────────── 💧 POÇÕES ─────────────────────────
  static const List<ConsumableItem> _potions = [
    ConsumableItem(
      id: 'potion.healing_minor',
      name: 'Poção de Cura Menor',
      description: 'Frasco azul translúcido. +80 HP.',
      rarity: Rarity.common,
      basePrice: 30,
      iconAsset: 'assets/images/items/potion_red.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: 80)],
    ),
    ConsumableItem(
      id: 'potion.healing_major',
      name: 'Poção de Cura Maior',
      description: '+250 HP.',
      rarity: Rarity.rare,
      basePrice: 180,
      iconAsset: 'assets/images/items/potion_red_big.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.healHp, amount: 250)],
    ),
    ConsumableItem(
      id: 'potion.mana_minor',
      name: 'Poção de Mana Menor',
      description: '+80 MP.',
      rarity: Rarity.common,
      basePrice: 30,
      iconAsset: 'assets/images/items/potion_blue.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.healMp, amount: 80)],
    ),
    ConsumableItem(
      id: 'potion.cure_burn',
      name: 'Bálsamo Anti-Queimadura',
      description: 'Remove queimadura.',
      rarity: Rarity.common,
      basePrice: 20,
      iconAsset: 'assets/images/items/potion_white.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(
        kind: ConsumableEffectKind.cureStatus,
        statusCured: StatusEffect.burn,
      )],
    ),
    ConsumableItem(
      id: 'potion.cure_poison',
      name: 'Antídoto Esmeralda',
      description: 'Remove envenenamento.',
      rarity: Rarity.common,
      basePrice: 20,
      iconAsset: 'assets/images/items/potion_green.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(
        kind: ConsumableEffectKind.cureStatus,
        statusCured: StatusEffect.poison,
      )],
    ),
    ConsumableItem(
      id: 'potion.awakener',
      name: 'Elixir do Despertar',
      description: 'Ativa o modo despertado imediatamente.',
      rarity: Rarity.epic,
      basePrice: 450,
      iconAsset: 'assets/images/items/potion_gold.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(kind: ConsumableEffectKind.awakenInstant)],
      flavor: 'Não funciona duas vezes na mesma batalha.',
    ),
    ConsumableItem(
      id: 'potion.xp_boost',
      name: 'Tônico do Estudioso',
      description: '+30% XP nos próximos 10 turnos.',
      rarity: Rarity.epic,
      basePrice: 300,
      iconAsset: 'assets/images/items/potion_purple.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(
        kind: ConsumableEffectKind.xpBoost, percent: 30, durationTurns: 10,
      )],
    ),
    ConsumableItem(
      id: 'potion.coin_boost',
      name: 'Tônico do Mercador',
      description: '+50% Lascas de Éon nos próximos 10 turnos.',
      rarity: Rarity.epic,
      basePrice: 400,
      iconAsset: 'assets/images/items/potion_yellow.png',
      subcategory: 'potion',
      effects: [ConsumableEffect(
        kind: ConsumableEffectKind.coinBoost, percent: 50, durationTurns: 10,
      )],
    ),
  ];

  // ───────────────────────── 🌿 MATERIAIS ─────────────────────────
  static const List<MaterialItem> _materials = [
    MaterialItem(
      id: 'mat.starthorn_herb',
      name: 'Erva de Estrela',
      description: 'Folha que brilha levemente no escuro.',
      rarity: Rarity.common, basePrice: 5,
      iconAsset: 'assets/images/items/mat_herb.png',
      subcategory: 'herb',
    ),
    MaterialItem(
      id: 'mat.moon_silver_ore',
      name: 'Minério de Prata-Luar',
      description: 'Pedaço bruto de prata extraída sob lua cheia.',
      rarity: Rarity.rare, basePrice: 60,
      iconAsset: 'assets/images/items/mat_ore.png',
      subcategory: 'ore',
    ),
    MaterialItem(
      id: 'mat.devourer_fang',
      name: 'Presa de Devorador',
      description: 'Dura como aço, leve como osso.',
      rarity: Rarity.epic, basePrice: 220,
      iconAsset: 'assets/images/items/mat_fang.png',
      subcategory: 'monsterPart',
    ),
    MaterialItem(
      id: 'mat.cursed_essence',
      name: 'Essência Amaldiçoada',
      description: 'Frasco selado. Não abra.',
      rarity: Rarity.epic, basePrice: 280,
      iconAsset: 'assets/images/items/mat_essence.png',
      subcategory: 'essence',
    ),
    MaterialItem(
      id: 'mat.silk_arcane',
      name: 'Seda Arcana',
      description: 'Tecido fino para roupas mágicas.',
      rarity: Rarity.rare, basePrice: 90,
      iconAsset: 'assets/images/items/mat_silk.png',
      subcategory: 'fabric',
    ),
    MaterialItem(
      id: 'mat.eon_shard_raw',
      name: 'Estilhaço Bruto de Éon',
      description: 'Cristal puro do Rio. Vale muito.',
      rarity: Rarity.legendary, basePrice: 900,
      iconAsset: 'assets/images/items/mat_shard.png',
      subcategory: 'gem',
    ),
  ];

  // ───────────────────────── 📖 LIVROS DE MAGIA ─────────────────────────
  static const List<SpellbookItem> _spellbooks = [
    SpellbookItem(
      id: 'book.fire.crimson_lance',
      name: 'Tomo: Lança Carmesim',
      description: 'Manuscrito de Velmoria. Ensina a Lança Carmesim.',
      rarity: Rarity.rare,
      basePrice: 250,
      iconAsset: 'assets/images/items/book_red.png',
      teachesAbilityId: 'grim.fire.crimson_lance',
      requiredSystem: PowerSystem.grimoire,
      requiredLevel: 8,
    ),
    SpellbookItem(
      id: 'book.dark.devourer',
      name: 'Tomo: Devorador de Mana',
      description: 'Capa de couro preta. Ensina o Devorador de Mana.',
      rarity: Rarity.epic,
      basePrice: 550,
      iconAsset: 'assets/images/items/book_black.png',
      teachesAbilityId: 'grim.dark.devourer',
      requiredSystem: PowerSystem.grimoire,
      requiredLevel: 18,
    ),
    SpellbookItem(
      id: 'book.jutsu.chidori',
      name: 'Pergaminho: Mil Pássaros',
      description: 'Pergaminho de Konsho. Ensina o jutsu Mil Pássaros.',
      rarity: Rarity.epic,
      basePrice: 700,
      iconAsset: 'assets/images/items/book_scroll.png',
      teachesAbilityId: 'jutsu.lightning.chidori',
      requiredSystem: PowerSystem.chakra,
      requiredLevel: 22,
    ),
    SpellbookItem(
      id: 'book.breath.water_f6',
      name: 'Pergaminho: Sexta Forma — Maré que Sobe',
      description: 'Manual da Respiração da Água.',
      rarity: Rarity.epic,
      basePrice: 620,
      iconAsset: 'assets/images/items/book_scroll_blue.png',
      teachesAbilityId: 'breath.water.form6',
      requiredSystem: PowerSystem.breathing,
      requiredLevel: 20,
    ),
    SpellbookItem(
      id: 'book.cursed.black_flash',
      name: 'Tratado: Flash Negro',
      description: 'Tinta amaldiçoada. Ensina o Flash Negro.',
      rarity: Rarity.legendary,
      basePrice: 1400,
      iconAsset: 'assets/images/items/book_cursed.png',
      teachesAbilityId: 'cursed.tech.black_flash',
      requiredSystem: PowerSystem.cursed,
      requiredLevel: 28,
    ),
    SpellbookItem(
      id: 'book.nen.spectral_blade',
      name: 'Manuscrito: Lâmina Espectral',
      description: 'Ensina a materializar uma lâmina de aura.',
      rarity: Rarity.epic,
      basePrice: 680,
      iconAsset: 'assets/images/items/book_green.png',
      teachesAbilityId: 'nen.materialization.spectral_blade',
      requiredSystem: PowerSystem.nen,
      requiredLevel: 24,
    ),
  ];

  // ───────────────────────── 📕 GRIMÓRIOS À VENDA ─────────────────────────
  static const List<GrimoireListing> _grimoires = [
    GrimoireListing(
      id: 'grim.listing.fire_3',
      name: 'Grimório de Chama (3F)',
      description: 'Três folhas. Elemento: Fogo.',
      rarity: Rarity.epic,
      basePrice: 2800,
      iconAsset: 'assets/images/items/grimoire_red.png',
      leaves: 3,
      element: Element.fire,
    ),
    GrimoireListing(
      id: 'grim.listing.dark_4',
      name: 'Grimório do Véu (4F)',
      description: 'Quatro folhas. Elemento: Escuridão.',
      rarity: Rarity.legendary,
      basePrice: 9500,
      iconAsset: 'assets/images/items/grimoire_black.png',
      leaves: 4,
      element: Element.dark,
    ),
    GrimoireListing(
      id: 'grim.listing.time_5',
      name: 'Grimório de Iyari (5F)',
      description: 'Cinco folhas. Elemento: Tempo. Praticamente lendário.',
      rarity: Rarity.transcendent,
      basePrice: 38000,
      iconAsset: 'assets/images/items/grimoire_gold.png',
      leaves: 5,
      element: Element.time,
      flavor: 'Apenas seis foram registrados em toda a história. Este é o sexto.',
    ),
  ];

  static final List<GameItem> _all = [
    ..._foods,
    ..._potions,
    ..._materials,
    ..._spellbooks,
    ..._grimoires,
  ];
}
