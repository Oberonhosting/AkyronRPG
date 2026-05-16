import '../../models/enums.dart';
import '../../systems/powers/power_base.dart';

/// Catálogo central de habilidades — todas as magias/jutsus/técnicas
/// disponíveis no jogo, indexadas por id.
///
/// Cada sistema de poder pode aprender só as suas (filtrando por `system`).
class AbilityCatalog {
  AbilityCatalog._();

  static final Map<String, Ability> _index = {
    for (final a in _all) a.id: a,
  };

  static Ability? byId(String id) => _index[id];
  static Iterable<Ability> bySystem(PowerSystem s) =>
      _all.where((a) => a.system == s);

  // ───────────────────────── Grimório ─────────────────────────
  static final List<Ability> _grimoireFire = [
    const Ability(
      id: 'grim.fire.ember_ray',
      name: 'Raio de Brasa',
      system: PowerSystem.grimoire,
      element: Element.fire,
      rarity: Rarity.common,
      basePower: 18, mpCost: 8,
      battleCry: 'RAIO DE BRASA!',
    ),
    const Ability(
      id: 'grim.fire.crimson_lance',
      name: 'Lança Carmesim',
      system: PowerSystem.grimoire,
      element: Element.fire,
      rarity: Rarity.rare,
      basePower: 36, mpCost: 18,
      statuses: [StatusEffect.burn],
      battleCry: 'LANÇA CARMESIM!!',
    ),
    const Ability(
      id: 'grim.fire.salamander_breath',
      name: 'Sopro da Salamandra Real',
      system: PowerSystem.grimoire,
      element: Element.fire,
      rarity: Rarity.epic,
      basePower: 72, mpCost: 36, hits: 2,
      battleCry: 'SOPRO DA SALAMANDRA!!!',
      flavor: 'Velmoria registra esta magia em três grimórios apenas.',
    ),
    const Ability(
      id: 'grim.fire.eternal_pyre',
      name: 'Pira Eterna do Sol Caído',
      system: PowerSystem.grimoire,
      element: Element.fire,
      rarity: Rarity.legendary,
      basePower: 160, mpCost: 80,
      targetsAll: true, isUltimate: true,
      statuses: [StatusEffect.burn],
      battleCry: '✦ PIRA ETERNA DO SOL CAÍDO ✦',
    ),
  ];

  static final List<Ability> _grimoireDark = [
    const Ability(
      id: 'grim.dark.shadow_grip',
      name: 'Garra das Sombras',
      system: PowerSystem.grimoire,
      element: Element.dark,
      rarity: Rarity.common,
      basePower: 20, mpCost: 10,
      statuses: [StatusEffect.paralysis],
      battleCry: 'GARRA DAS SOMBRAS!',
    ),
    const Ability(
      id: 'grim.dark.devourer',
      name: 'Devorador de Mana',
      system: PowerSystem.grimoire,
      element: Element.dark,
      rarity: Rarity.epic,
      basePower: 64, mpCost: 25,
      battleCry: 'DEVORADOR DE MANA!!',
    ),
    const Ability(
      id: 'grim.dark.eternal_night',
      name: 'Véu da Noite-Sem-Fim',
      system: PowerSystem.grimoire,
      element: Element.dark,
      rarity: Rarity.legendary,
      basePower: 180, mpCost: 90,
      targetsAll: true, isUltimate: true,
      battleCry: '✦ NOITE-SEM-FIM ✦',
      flavor: 'Apenas portadores de 4F ou mais conseguem invocar.',
    ),
  ];

  static final List<Ability> _grimoireTime = [
    const Ability(
      id: 'grim.time.slow_step',
      name: 'Passo Lento',
      system: PowerSystem.grimoire,
      element: Element.time,
      rarity: Rarity.rare,
      basePower: 12, mpCost: 22,
      statuses: [StatusEffect.stun],
      battleCry: 'PASSO LENTO!',
    ),
    const Ability(
      id: 'grim.time.rewind',
      name: 'Iyari da Ampulheta',
      system: PowerSystem.grimoire,
      element: Element.time,
      rarity: Rarity.transcendent,
      basePower: 0, mpCost: 120,
      isUltimate: true,
      battleCry: '✦ IYARI DA AMPULHETA ✦',
      flavor: 'Reverte o último turno do usuário.',
    ),
  ];

  // ───────────────────────── Zanpakutō ─────────────────────────
  static final List<Ability> _zanSlashes = [
    const Ability(
      id: 'zan.cut.slash',
      name: 'Corte Lunar',
      system: PowerSystem.zanpakuto,
      element: Element.dark,
      rarity: Rarity.common,
      basePower: 24, mpCost: 6,
      battleCry: 'CORTE LUNAR!',
    ),
    const Ability(
      id: 'zan.cut.howling_wolf',
      name: 'Lobo que Uiva ao Aço',
      system: PowerSystem.zanpakuto,
      element: Element.wind,
      rarity: Rarity.rare,
      basePower: 44, mpCost: 14, hits: 3,
      battleCry: 'LOBO QUE UIVA AO AÇO!',
    ),
    const Ability(
      id: 'zan.bankai.tsukibarai',
      name: 'BANKAI — Tsukibarai',
      system: PowerSystem.zanpakuto,
      element: Element.ice,
      rarity: Rarity.legendary,
      basePower: 220, mpCost: 90,
      isUltimate: true,
      battleCry: '✦ BANKAI — TSUKIBARAI ✦',
      flavor: 'A lua varre o campo. Tudo que ela ilumina, ela conhece.',
    ),
  ];

  // ───────────────────────── Chakra ─────────────────────────
  static final List<Ability> _jutsus = [
    const Ability(
      id: 'jutsu.fire.phoenix',
      name: 'Bola de Fogo da Fênix',
      system: PowerSystem.chakra,
      element: Element.fire,
      rarity: Rarity.rare,
      basePower: 40, mpCost: 10, chakraCost: 14,
      battleCry: 'FÊNIX!!',
    ),
    const Ability(
      id: 'jutsu.water.dragon',
      name: 'Dragão d\'Água',
      system: PowerSystem.chakra,
      element: Element.water,
      rarity: Rarity.rare,
      basePower: 42, mpCost: 8, chakraCost: 16,
      battleCry: 'DRAGÃO D\'ÁGUA!',
    ),
    const Ability(
      id: 'jutsu.lightning.chidori',
      name: 'Mil Pássaros',
      system: PowerSystem.chakra,
      element: Element.lightning,
      rarity: Rarity.epic,
      basePower: 95, mpCost: 12, chakraCost: 28,
      battleCry: 'MIL PÁSSAROS!!!',
    ),
    const Ability(
      id: 'jutsu.sage.frog_sage_kata',
      name: 'Kata do Sapo Sábio',
      system: PowerSystem.chakra,
      element: Element.earth,
      rarity: Rarity.epic,
      basePower: 88, mpCost: 0, chakraCost: 24, hits: 3,
      battleCry: 'KATA DO SAPO SÁBIO!',
    ),
    const Ability(
      id: 'jutsu.sixpaths.sun',
      name: 'Disco Solar dos Seis Caminhos',
      system: PowerSystem.chakra,
      element: Element.light,
      rarity: Rarity.legendary,
      basePower: 250, mpCost: 50, chakraCost: 80,
      isUltimate: true, targetsAll: true,
      battleCry: '✦ DISCO SOLAR DOS SEIS CAMINHOS ✦',
    ),
  ];

  // ───────────────────────── Respirações ─────────────────────────
  static final List<Ability> _breathing = [
    const Ability(
      id: 'breath.water.form1',
      name: 'Água — Primeira Forma: Corte da Superfície',
      system: PowerSystem.breathing,
      element: Element.water,
      rarity: Rarity.common,
      basePower: 28, mpCost: 6,
      battleCry: 'PRIMEIRA FORMA — CORTE DA SUPERFÍCIE!',
    ),
    const Ability(
      id: 'breath.water.form6',
      name: 'Água — Sexta Forma: Maré que Sobe',
      system: PowerSystem.breathing,
      element: Element.water,
      rarity: Rarity.epic,
      basePower: 78, mpCost: 18, hits: 2,
      battleCry: 'SEXTA FORMA — MARÉ QUE SOBE!',
    ),
    const Ability(
      id: 'breath.water.form11',
      name: 'Água — Forma Superior: Calmaria que Apaga',
      system: PowerSystem.breathing,
      element: Element.water,
      rarity: Rarity.legendary,
      basePower: 210, mpCost: 60,
      isUltimate: true,
      battleCry: '✦ FORMA SUPERIOR — CALMARIA QUE APAGA ✦',
    ),
    const Ability(
      id: 'breath.thunder.form1',
      name: 'Trovão — Primeira Forma: Raio Direto',
      system: PowerSystem.breathing,
      element: Element.lightning,
      rarity: Rarity.common,
      basePower: 34, mpCost: 8,
      battleCry: 'PRIMEIRA FORMA — RAIO DIRETO!',
    ),
    const Ability(
      id: 'breath.sun.form12',
      name: 'Sol — Décima Segunda Forma: Dança do Deus do Fogo',
      system: PowerSystem.breathing,
      element: Element.light,
      rarity: Rarity.transcendent,
      basePower: 300, mpCost: 90,
      isUltimate: true,
      battleCry: '✦ DANÇA DO DEUS DO FOGO ✦',
    ),
  ];

  // ───────────────────────── Nen ─────────────────────────
  static final List<Ability> _nen = [
    const Ability(
      id: 'nen.basic.ko',
      name: 'Ko — Aura Concentrada',
      system: PowerSystem.nen,
      element: Element.life,
      rarity: Rarity.common,
      basePower: 22, mpCost: 6,
      battleCry: 'KO!',
    ),
    const Ability(
      id: 'nen.emission.aura_bullet',
      name: 'Bala de Aura',
      system: PowerSystem.nen,
      element: Element.life,
      rarity: Rarity.rare,
      basePower: 50, mpCost: 14, hits: 2,
      battleCry: 'BALA DE AURA!',
    ),
    const Ability(
      id: 'nen.materialization.spectral_blade',
      name: 'Lâmina Espectral Materializada',
      system: PowerSystem.nen,
      element: Element.life,
      rarity: Rarity.epic,
      basePower: 90, mpCost: 24,
      battleCry: 'LÂMINA ESPECTRAL!',
    ),
    const Ability(
      id: 'nen.personal.zetsu_ambush',
      name: 'Emboscada — Zetsu Vivo',
      system: PowerSystem.nen,
      element: Element.life,
      rarity: Rarity.legendary,
      basePower: 180, mpCost: 60,
      isUltimate: true,
      battleCry: '✦ EMBOSCADA — ZETSU VIVO ✦',
      flavor: 'Só funciona com pelo menos um juramento ativo.',
    ),
  ];

  // ───────────────────────── Energia Amaldiçoada ─────────────────────────
  static final List<Ability> _cursed = [
    const Ability(
      id: 'cursed.basic.fist',
      name: 'Soco Reforçado',
      system: PowerSystem.cursed,
      element: Element.dark,
      rarity: Rarity.common,
      basePower: 26, mpCost: 0, cursedCost: 8,
      battleCry: 'SOCO REFORÇADO!',
    ),
    const Ability(
      id: 'cursed.tech.divergent_fist',
      name: 'Punho Divergente',
      system: PowerSystem.cursed,
      element: Element.dark,
      rarity: Rarity.rare,
      basePower: 64, mpCost: 0, cursedCost: 18,
      battleCry: 'PUNHO DIVERGENTE!!',
    ),
    const Ability(
      id: 'cursed.tech.black_flash',
      name: 'Flash Negro',
      system: PowerSystem.cursed,
      element: Element.dark,
      rarity: Rarity.epic,
      basePower: 140, mpCost: 0, cursedCost: 32,
      battleCry: 'FLASH NEGRO!!!',
      flavor: 'Janela de timing perfeita multiplica o dano.',
    ),
    const Ability(
      id: 'cursed.domain.endless_void',
      name: 'EXPANSÃO DE TERRITÓRIO — Vazio Sem Fim',
      system: PowerSystem.cursed,
      element: Element.dark,
      rarity: Rarity.transcendent,
      basePower: 280, mpCost: 40, cursedCost: 90,
      isUltimate: true, targetsAll: true,
      battleCry: '✦ EXPANSÃO DE TERRITÓRIO — VAZIO SEM FIM ✦',
      flavor: 'A arena muda. A técnica não pode errar.',
    ),
  ];

  static final List<Ability> _all = [
    ..._grimoireFire,
    ..._grimoireDark,
    ..._grimoireTime,
    ..._zanSlashes,
    ..._jutsus,
    ..._breathing,
    ..._nen,
    ..._cursed,
  ];
}
