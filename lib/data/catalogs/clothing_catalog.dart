import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/equipment.dart';
import '../../models/stats.dart';

/// Catálogo de roupas e acessórios visíveis no avatar.
/// Pixel art real será conectada depois — por enquanto, cada item tem um
/// asset placeholder e cor base/accent para o sistema de tinta.
class ClothingCatalog {
  ClothingCatalog._();

  static final Map<String, ClothingItem> _index = {
    for (final c in _all) c.id: c,
  };

  static ClothingItem? byId(String id) => _index[id];
  static Iterable<ClothingItem> all() => _all;
  static Iterable<ClothingItem> bySlot(EquipSlot s) =>
      _all.where((c) => c.slot == s);

  static final List<SetBonus> setBonuses = [
    SetBonus(
      setId: 'set.crimson_archmage',
      name: 'Arquimago Carmesim',
      description: 'O fogo lembra dos seus passos.',
      requiredPieces: 4,
      bonus: Stats(spirit: 12, maxMp: 30, focus: 6),
    ),
    SetBonus(
      setId: 'set.silver_captain',
      name: 'Capitão de Aço',
      description: 'O aço de Shirogane reconhece o portador.',
      requiredPieces: 4,
      bonus: Stats(attack: 14, defense: 10, crit: 4),
    ),
    SetBonus(
      setId: 'set.lunar_dancer',
      name: 'Dançarina Lunar',
      description: 'A bruma anda com você. As lâminas adoram.',
      requiredPieces: 4,
      bonus: Stats(speed: 8, evasion: 10, crit: 6),
    ),
    SetBonus(
      setId: 'set.cursed_marked',
      name: 'Marcado pela Maldição',
      description: 'A marca não esconde mais — ela canta.',
      requiredPieces: 4,
      bonus: Stats(maxCursedEnergy: 40, spirit: 8, attack: 6),
    ),
  ];

  // ============= CABEÇA =============
  static final List<ClothingItem> _heads = [
    ClothingItem(
      id: 'head.mage_hat_violet',
      name: 'Chapéu de Mago Violeta',
      slot: EquipSlot.head,
      rarity: Rarity.common,
      spriteAsset: 'assets/images/clothing/head_mage_hat.png',
      tintMain: const Color(0xFF6E3FBF),
      tintAccent: const Color(0xFFE8C547),
      flavor: 'Tradicional em Velmoria. Aba longa para esconder o olhar.',
    ),
    ClothingItem(
      id: 'head.captain_helm',
      name: 'Elmo de Capitão de Aço',
      slot: EquipSlot.head,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/head_captain_helm.png',
      tintMain: const Color(0xFFB8C0D0),
      tintAccent: const Color(0xFFE8C547),
      setId: 'set.silver_captain',
      flavor: 'Cada batida no aço é registrada por dentro.',
    ),
    ClothingItem(
      id: 'head.ninja_band_leaf',
      name: 'Bandana de Konsho — Folha',
      slot: EquipSlot.head,
      rarity: Rarity.common,
      spriteAsset: 'assets/images/clothing/head_ninja_band.png',
      tintMain: const Color(0xFF1A1A1A),
      tintAccent: const Color(0xFF63E07A),
      flavor: 'Metal gravado com o símbolo da vila.',
    ),
    ClothingItem(
      id: 'head.demon_mask',
      name: 'Máscara de Caçador',
      slot: EquipSlot.head,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/head_demon_mask.png',
      tintMain: const Color(0xFFE0EAF0),
      tintAccent: const Color(0xFFB02FE0),
      flavor: 'Esculpida em cipreste. Pesa pouco. Vê muito.',
    ),
    ClothingItem(
      id: 'head.tiara_arcane',
      name: 'Tiara Arcana de Yorokai',
      slot: EquipSlot.head,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/head_tiara.png',
      tintMain: const Color(0xFFE8C547),
      tintAccent: const Color(0xFF4FF0E8),
      allowedGenders: const {Gender.feminine},
      flavor: 'Pedra central reage à aura de quem a usa.',
    ),
  ];

  // ============= TOPO =============
  static final List<ClothingItem> _tops = [
    ClothingItem(
      id: 'top.leather_corset_m',
      name: 'Corset de Couro Reforçado',
      slot: EquipSlot.top,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/top_corset_leather_m.png',
      tintMain: const Color(0xFF6E3A1F),
      tintAccent: const Color(0xFFE8C547),
      allowedGenders: const {Gender.masculine},
      flavor: 'Corset medieval masculino, ajustado para luta de espada.',
    ),
    ClothingItem(
      id: 'top.metal_corset_m',
      name: 'Corset Metálico Bordado',
      slot: EquipSlot.top,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/top_corset_metal_m.png',
      tintMain: const Color(0xFFB8C0D0),
      tintAccent: const Color(0xFFE8C547),
      setId: 'set.silver_captain',
      allowedGenders: const {Gender.masculine},
      flavor: 'Lâminas finas de aço polido sobre tecido escuro.',
    ),
    ClothingItem(
      id: 'top.captain_coat_long',
      name: 'Casacão de Capitão',
      slot: EquipSlot.top,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/top_captain_coat.png',
      tintMain: const Color(0xFF101020),
      tintAccent: const Color(0xFFE8C547),
      flavor: 'Cauda longa, ombros marcados, bordados em fio dourado.',
    ),
    ClothingItem(
      id: 'top.open_kimono',
      name: 'Kimono Aberto de Combate',
      slot: EquipSlot.top,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/top_open_kimono.png',
      tintMain: const Color(0xFF2A2A40),
      tintAccent: const Color(0xFFE0285A),
      flavor: 'Aberto no peito. Mostra a marca rúnica do portador.',
    ),
    ClothingItem(
      id: 'top.gold_armor',
      name: 'Armadura com Detalhes Dourados',
      slot: EquipSlot.top,
      rarity: Rarity.legendary,
      spriteAsset: 'assets/images/clothing/top_gold_armor.png',
      tintMain: const Color(0xFFC8C8D0),
      tintAccent: const Color(0xFFE8C547),
      setId: 'set.silver_captain',
      bonusStats: Stats(defense: 6),
      flavor: 'Peitoral com runas que brilham fraco no escuro.',
    ),
    ClothingItem(
      id: 'top.runic_shirt',
      name: 'Camisa de Padrões Rúnicos',
      slot: EquipSlot.top,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/top_runic_shirt.png',
      tintMain: const Color(0xFF3A1B5C),
      tintAccent: const Color(0xFF4FF0E8),
      flavor: 'Os símbolos se reorganizam quando ninguém olha.',
    ),
    ClothingItem(
      id: 'top.mage_mantle',
      name: 'Manto com Bordados Mágicos',
      slot: EquipSlot.top,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/top_mage_mantle.png',
      tintMain: const Color(0xFF4A1F8A),
      tintAccent: const Color(0xFFE8C547),
      setId: 'set.crimson_archmage',
      flavor: 'Bordados que respondem a feitiços com brilho.',
    ),
    ClothingItem(
      id: 'top.floral_corset_f',
      name: 'Corset Elegante Floral',
      slot: EquipSlot.top,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/top_corset_floral_f.png',
      tintMain: const Color(0xFF2A0F2A),
      tintAccent: const Color(0xFFE0285A),
      allowedGenders: const {Gender.feminine},
      flavor: 'Detalhes florais bordados em fio carmim sobre tecido escuro.',
    ),
    ClothingItem(
      id: 'top.arcane_corset_f',
      name: 'Corset Arcano com Cristal',
      slot: EquipSlot.top,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/top_corset_arcane_f.png',
      tintMain: const Color(0xFF6E3FBF),
      tintAccent: const Color(0xFF4FF0E8),
      allowedGenders: const {Gender.feminine},
      setId: 'set.crimson_archmage',
      flavor: 'Pedra central reage ao tipo de poder de quem veste.',
    ),
    ClothingItem(
      id: 'top.battle_dress',
      name: 'Vestido de Batalha',
      slot: EquipSlot.top,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/top_battle_dress.png',
      tintMain: const Color(0xFF8A1A3B),
      tintAccent: const Color(0xFFE8C547),
      allowedGenders: const {Gender.feminine},
      flavor: 'Saiote dividido em três fendas para liberdade de chute.',
    ),
    ClothingItem(
      id: 'top.combat_kimono_f',
      name: 'Kimono de Combate',
      slot: EquipSlot.top,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/top_combat_kimono.png',
      tintMain: const Color(0xFF1A2A4A),
      tintAccent: const Color(0xFFE0285A),
      allowedGenders: const {Gender.feminine},
      flavor: 'Faixa larga na cintura, ombros livres.',
    ),
    ClothingItem(
      id: 'top.hooded_cape_f',
      name: 'Capa Encantada com Capuz',
      slot: EquipSlot.top,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/top_hooded_cape.png',
      tintMain: const Color(0xFF1B0F2B),
      tintAccent: const Color(0xFF7A2EE0),
      allowedGenders: const {Gender.feminine},
      flavor: 'O capuz reage ao luar, brilha em violeta.',
    ),
  ];

  // ============= INFERIOR =============
  static final List<ClothingItem> _bottoms = [
    ClothingItem(
      id: 'bot.combat_pants',
      name: 'Calça de Combate',
      slot: EquipSlot.bottom,
      rarity: Rarity.common,
      spriteAsset: 'assets/images/clothing/bot_combat_pants.png',
      tintMain: const Color(0xFF2A2A2A),
      tintAccent: const Color(0xFFE8C547),
      flavor: 'Tecido reforçado nos joelhos.',
    ),
    ClothingItem(
      id: 'bot.split_skirt',
      name: 'Saia com Fenda Dupla',
      slot: EquipSlot.bottom,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/bot_split_skirt.png',
      tintMain: const Color(0xFF1A0F2B),
      tintAccent: const Color(0xFFE0285A),
      allowedGenders: const {Gender.feminine},
      flavor: 'Fendas até o quadril — espaço para magia, espada e fuga.',
    ),
    ClothingItem(
      id: 'bot.hakama',
      name: 'Hakama Tradicional',
      slot: EquipSlot.bottom,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/bot_hakama.png',
      tintMain: const Color(0xFF111122),
      tintAccent: const Color(0xFFB8C0D0),
      flavor: 'Sete pregas, cada uma com um significado em Shirogane.',
    ),
    ClothingItem(
      id: 'bot.greaves',
      name: 'Grevas Reforçadas',
      slot: EquipSlot.bottom,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/bot_greaves.png',
      tintMain: const Color(0xFFB8C0D0),
      tintAccent: const Color(0xFFE8C547),
      setId: 'set.silver_captain',
    ),
  ];

  // ============= CALÇADO =============
  static final List<ClothingItem> _footwear = [
    ClothingItem(
      id: 'foot.medieval_boots',
      name: 'Botas Medievais',
      slot: EquipSlot.footwear,
      rarity: Rarity.common,
      spriteAsset: 'assets/images/clothing/foot_medieval_boots.png',
      tintMain: const Color(0xFF3B2A1A),
      tintAccent: const Color(0xFFE8C547),
    ),
    ClothingItem(
      id: 'foot.ninja_sandals',
      name: 'Sandálias Ninja',
      slot: EquipSlot.footwear,
      rarity: Rarity.common,
      spriteAsset: 'assets/images/clothing/foot_ninja_sandals.png',
      tintMain: const Color(0xFF1A1A1A),
      tintAccent: const Color(0xFF63E07A),
      flavor: 'Solas finas para sentir o chão antes do inimigo.',
    ),
    ClothingItem(
      id: 'foot.arcane_shoes',
      name: 'Sapatos Arcanos',
      slot: EquipSlot.footwear,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/foot_arcane_shoes.png',
      tintMain: const Color(0xFF6E3FBF),
      tintAccent: const Color(0xFFE8C547),
      setId: 'set.crimson_archmage',
      flavor: 'Quase não fazem barulho. Quase.',
    ),
  ];

  // ============= MANTO / CAPA =============
  static final List<ClothingItem> _cloaks = [
    ClothingItem(
      id: 'cloak.feathered',
      name: 'Manto de Penas',
      slot: EquipSlot.cloak,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/cloak_feathered.png',
      tintMain: const Color(0xFF101020),
      tintAccent: const Color(0xFFE8C547),
      flavor: 'Cada pena é um voto que o portador não cumpriu.',
    ),
    ClothingItem(
      id: 'cloak.captain_haori',
      name: 'Haori de Capitão',
      slot: EquipSlot.cloak,
      rarity: Rarity.legendary,
      spriteAsset: 'assets/images/clothing/cloak_captain_haori.png',
      tintMain: const Color(0xFFE9DDB6),
      tintAccent: const Color(0xFFE0285A),
      setId: 'set.silver_captain',
      bonusStats: Stats(spirit: 6, defense: 4),
      flavor: 'Forrado em vermelho. Símbolo do esquadrão atrás.',
    ),
    ClothingItem(
      id: 'cloak.cursed_robe',
      name: 'Túnica Amaldiçoada',
      slot: EquipSlot.cloak,
      rarity: Rarity.legendary,
      spriteAsset: 'assets/images/clothing/cloak_cursed_robe.png',
      tintMain: const Color(0xFF2B0F2B),
      tintAccent: const Color(0xFFB02FE0),
      setId: 'set.cursed_marked',
      flavor: 'O bordado se move quando você não olha diretamente.',
    ),
  ];

  // ============= ACESSÓRIOS =============
  static final List<ClothingItem> _accessories = [
    ClothingItem(
      id: 'acc.crescent_earrings',
      name: 'Brincos de Lua Crescente',
      slot: EquipSlot.accessory,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/acc_earrings.png',
      tintMain: const Color(0xFFE8C547),
    ),
    ClothingItem(
      id: 'acc.necklace_orb',
      name: 'Colar com Orbe Espiritual',
      slot: EquipSlot.accessory,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/acc_necklace.png',
      tintMain: const Color(0xFF4FF0E8),
    ),
    ClothingItem(
      id: 'acc.rune_bracelet',
      name: 'Pulseira Rúnica',
      slot: EquipSlot.accessory,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/clothing/acc_bracelet.png',
      tintMain: const Color(0xFF7A2EE0),
    ),
    ClothingItem(
      id: 'acc.skin_runes',
      name: 'Marcas Rúnicas Brilhantes (pele)',
      slot: EquipSlot.accessory,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/clothing/acc_skin_runes.png',
      tintMain: const Color(0xFFE8C547),
      flavor: 'Aparecem só em combate. Mudam de forma a cada despertar.',
    ),
  ];

  // ============= AURAS =============
  static final List<ClothingItem> _auras = [
    ClothingItem(
      id: 'aura.violet_flame',
      name: 'Aura — Chama Violeta',
      slot: EquipSlot.aura,
      rarity: Rarity.epic,
      spriteAsset: 'assets/images/effects/aura_violet.png',
      tintMain: const Color(0xFF7A2EE0),
    ),
    ClothingItem(
      id: 'aura.golden_dust',
      name: 'Aura — Pó Dourado',
      slot: EquipSlot.aura,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/effects/aura_gold.png',
      tintMain: const Color(0xFFE8C547),
    ),
    ClothingItem(
      id: 'aura.cyan_spirit',
      name: 'Aura — Espírito Ciano',
      slot: EquipSlot.aura,
      rarity: Rarity.rare,
      spriteAsset: 'assets/images/effects/aura_cyan.png',
      tintMain: const Color(0xFF4FF0E8),
    ),
    ClothingItem(
      id: 'aura.cursed_smoke',
      name: 'Aura — Fumaça Amaldiçoada',
      slot: EquipSlot.aura,
      rarity: Rarity.legendary,
      spriteAsset: 'assets/images/effects/aura_cursed.png',
      tintMain: const Color(0xFFB02FE0),
      setId: 'set.cursed_marked',
    ),
  ];

  static final List<ClothingItem> _all = [
    ..._heads,
    ..._tops,
    ..._bottoms,
    ..._footwear,
    ..._cloaks,
    ..._accessories,
    ..._auras,
  ];
}
