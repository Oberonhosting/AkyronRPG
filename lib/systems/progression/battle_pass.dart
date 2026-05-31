/// Battle Pass sazonal. Faixa gratuita e premium, ambas com 50 níveis.
/// Cada nível dá uma skin, item ou moeda. Tema da temporada muda o nome do
/// pass.

class BpReward {
  const BpReward({
    required this.tier,
    required this.premium,
    required this.itemId,
    required this.label,
  });

  final int tier;
  final bool premium;
  final String itemId;
  final String label;
}

class BattlePassSeason {
  const BattlePassSeason({
    required this.id,
    required this.name,
    required this.lore,
    required this.rewards,
    required this.endDate,
  });

  final String id;
  final String name;
  final String lore;
  final List<BpReward> rewards;
  final DateTime endDate;
}

class BattlePassState {
  BattlePassState({
    required this.seasonId,
    this.xp = 0,
    this.premium = false,
    Set<String>? claimed,
  }) : claimed = claimed ?? <String>{};

  String seasonId;
  int xp;
  bool premium;
  Set<String> claimed;

  int get tier => (xp / 1000).floor().clamp(0, 50);

  void award(int amount) => xp += amount;
}

class BattlePassRegistry {
  BattlePassRegistry._();

  static final BattlePassSeason current = BattlePassSeason(
    id: 'season.fractured_eclipse',
    name: 'Temporada I — Eclipse Fraturado',
    lore: 'A bruma de Sukhenna se espalhou. Quem caça hoje, é caçado amanhã.',
    endDate: DateTime.utc(2026, 8, 30),
    rewards: [
      const BpReward(tier: 1, premium: false, itemId: 'aura.golden_dust', label: 'Aura Dourada'),
      const BpReward(tier: 5, premium: false, itemId: 'head.ninja_band_leaf', label: 'Bandana Folha'),
      const BpReward(tier: 10, premium: false, itemId: 'top.runic_shirt', label: 'Camisa Rúnica'),
      const BpReward(tier: 15, premium: true, itemId: 'top.captain_coat_long', label: 'Casacão Capitão'),
      const BpReward(tier: 20, premium: true, itemId: 'cloak.cursed_robe', label: 'Túnica Amaldiçoada'),
      const BpReward(tier: 30, premium: true, itemId: 'top.gold_armor', label: 'Armadura Dourada'),
      const BpReward(tier: 50, premium: true, itemId: 'cloak.captain_haori', label: 'Haori Capitão'),
    ],
  );
}
