/// Loja de NPC. Tem um conjunto fixo de itens à venda, e cada NPC
/// também aceita comprar itens que o jogador trouxer (geralmente por
/// 40-60% do preço base).
class NpcShop {
  const NpcShop({
    required this.id,
    required this.name,
    required this.npc,
    required this.region,
    required this.stock,
    required this.buybackRate,
    this.greeting = '',
    this.specialty = '',
  });

  final String id;
  final String name;
  final String npc;
  final String region;

  /// IDs de itens em estoque (ItemCatalog ou ClothingCatalog).
  final List<String> stock;

  /// Quanto a loja paga ao comprar do jogador. 0.5 = metade do basePrice.
  final double buybackRate;

  final String greeting;
  final String specialty;
}

class ShopCatalog {
  ShopCatalog._();

  static const List<NpcShop> all = [
    // ───────── Espinho-de-Estrela ─────────
    NpcShop(
      id: 'shop.starthorn.general',
      name: 'Armazém do Velho Eron',
      npc: 'Eron Caldeira-Quente',
      region: 'region.starthorn',
      buybackRate: 0.5,
      greeting: '"Tudo que cabe no balcão, eu vendo. Tudo que sobra, eu compro."',
      specialty: 'Geral',
      stock: [
        'food.barley_bread', 'food.travel_ration', 'food.mage_tea',
        'potion.healing_minor', 'potion.mana_minor',
        'potion.cure_burn', 'potion.cure_poison',
        'mat.starthorn_herb',
      ],
    ),
    NpcShop(
      id: 'shop.starthorn.smith',
      name: 'Forja do Punhal Torto',
      npc: 'Mestra Reza',
      region: 'region.starthorn',
      buybackRate: 0.55,
      greeting: '"Material bom? Mostra. Material ruim? Volta amanhã."',
      specialty: 'Materiais e armas básicas',
      stock: [
        'mat.moon_silver_ore', 'mat.silk_arcane',
      ],
    ),

    // ───────── Velmoria / Torre dos Magos ─────────
    NpcShop(
      id: 'shop.velmoria.tomes',
      name: 'Biblioteca de Pergaminhos Vendidos',
      npc: 'Bibliotecário Ven',
      region: 'region.mage_tower',
      buybackRate: 0.45,
      greeting: '"Cada livro daqui foi escrito por quem o mereceu."',
      specialty: 'Livros que ensinam magias',
      stock: [
        'book.fire.crimson_lance',
        'book.dark.devourer',
        'book.breath.water_f6',
        'book.nen.spectral_blade',
      ],
    ),
    NpcShop(
      id: 'shop.velmoria.alchemy',
      name: 'Casa de Frascos da Iyari',
      npc: 'Alquimista Suri',
      region: 'region.mage_tower',
      buybackRate: 0.5,
      greeting: '"O frasco roxo é caro. Mas é o único que funciona."',
      specialty: 'Poções avançadas',
      stock: [
        'potion.healing_major', 'potion.awakener',
        'potion.xp_boost', 'potion.coin_boost',
        'food.spirit_dumpling', 'food.eon_rice',
      ],
    ),

    // ───────── Konsho ─────────
    NpcShop(
      id: 'shop.konsho.scrolls',
      name: 'Pergaminhos da Folha-do-Lago',
      npc: 'Jōnin Aposentado Kuma',
      region: 'region.arcane_forest',
      buybackRate: 0.5,
      greeting: '"Comprou? Treina. Não treinou? Não comprou."',
      specialty: 'Jutsus e pílulas',
      stock: [
        'book.jutsu.chidori',
        'food.chakra_pill',
        'food.crow_stew',
      ],
    ),

    // ───────── Sukhenna ─────────
    NpcShop(
      id: 'shop.sukhenna.cursed',
      name: 'Caixa da Marca Aberta',
      npc: 'Feiticeira sem nome',
      region: 'region.cursed_lands',
      buybackRate: 0.65,
      greeting: '"O preço é alto. O risco é seu."',
      specialty: 'Itens amaldiçoados',
      stock: [
        'book.cursed.black_flash',
        'food.cursed_candy',
        'mat.cursed_essence',
        'mat.eon_shard_raw',
      ],
    ),

    // ───────── Grimórios — mercado secreto ─────────
    NpcShop(
      id: 'shop.grimoire.black_market',
      name: 'Leilão de Folhas',
      npc: 'Anônimo',
      region: 'region.mage_tower',
      buybackRate: 0.7,
      greeting: '"Você não está aqui. Eu também não. Nada disso acontece."',
      specialty: 'Grimórios',
      stock: [
        'grim.listing.fire_3',
        'grim.listing.dark_4',
        'grim.listing.time_5',
      ],
    ),
  ];

  static NpcShop? byId(String id) =>
      all.cast<NpcShop?>().firstWhere((s) => s?.id == id, orElse: () => null);

  static Iterable<NpcShop> byRegion(String region) =>
      all.where((s) => s.region == region);
}
