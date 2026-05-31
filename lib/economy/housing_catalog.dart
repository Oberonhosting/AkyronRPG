/// Propriedade que o jogador pode comprar (casa). Cada região tem seu
/// próprio mercado imobiliário. Casas dão storage extra, fast-travel e
/// algumas features especiais (workshop de craft, jardim de ervas, etc.).
class House {
  const House({
    required this.id,
    required this.name,
    required this.region,
    required this.price,
    required this.storageSlots,
    required this.fastTravel,
    this.tier = 'common',
    this.features = const [],
    this.description = '',
  });

  final String id;
  final String name;
  final String region;
  final int price;            // em Lascas de Éon
  final int storageSlots;     // baú extra
  final bool fastTravel;      // ao tocar na cama, vai pra essa casa
  final String tier;          // 'common', 'comfortable', 'manor', 'estate'
  final List<String> features;
  final String description;
}

/// Quarto de hotel — aluguel por noite. Curativo + buffs temporários.
class HotelRoom {
  const HotelRoom({
    required this.id,
    required this.hotelName,
    required this.region,
    required this.tier,
    required this.pricePerNight,
    required this.healPercent,
    this.buffs = const [],
    this.description = '',
  });

  final String id;
  final String hotelName;
  final String region;

  /// 'spartan' (pousada), 'comfortable' (quarto), 'royal' (suíte)
  final String tier;
  final int pricePerNight;

  /// Quanto cura ao dormir (0..100 = % do HP/MP/Chakra/CE).
  final int healPercent;

  /// Buffs temporários ao acordar (ex.: 'rested', 'inspired',
  /// 'eonAttuned'). Ficam por algumas batalhas.
  final List<String> buffs;
  final String description;
}

class HousingCatalog {
  HousingCatalog._();

  static const List<House> houses = [
    // Vila de Espinho-de-Estrela — barato, primeira casa.
    House(
      id: 'house.starthorn.cottage',
      name: 'Cabana de Espinho-de-Estrela',
      region: 'region.starthorn',
      price: 1500,
      storageSlots: 30,
      fastTravel: true,
      tier: 'common',
      features: ['cama', 'baú', 'lareira'],
      description: 'Pequena, de madeira escura. Ideal pra começar.',
    ),
    House(
      id: 'house.starthorn.farm',
      name: 'Sítio da Borda da Floresta',
      region: 'region.starthorn',
      price: 4200,
      storageSlots: 60,
      fastTravel: true,
      tier: 'comfortable',
      features: ['cama', 'baú', 'lareira', 'jardim de ervas'],
      description: 'Plante ervas para usar em poções caseiras.',
    ),

    // Velmoria — Torre dos Magos.
    House(
      id: 'house.velmoria.tower_flat',
      name: 'Apartamento na Torre',
      region: 'region.mage_tower',
      price: 6800,
      storageSlots: 50,
      fastTravel: true,
      tier: 'comfortable',
      features: ['cama', 'baú', 'biblioteca', 'mesa de runas'],
      description: 'Andar 14 da Torre dos Magos. Vista para os escribas.',
    ),
    House(
      id: 'house.velmoria.manor',
      name: 'Casarão do Bairro Antigo',
      region: 'region.mage_tower',
      price: 22000,
      storageSlots: 120,
      fastTravel: true,
      tier: 'manor',
      features: ['cama', 'baú', 'lareira', 'biblioteca', 'oficina', 'jardim'],
      description: 'Três andares, lareira que nunca apaga.',
    ),

    // Shirogane.
    House(
      id: 'house.shirogane.dojo_room',
      name: 'Quarto no Dojo de Shirogane',
      region: 'region.spirit_plane',
      price: 5400,
      storageSlots: 40,
      fastTravel: true,
      tier: 'comfortable',
      features: ['cama', 'baú', 'altar do espírito'],
      description: 'Converse com o espírito da sua zanpaku-tō ao meditar.',
    ),

    // Karasuho.
    House(
      id: 'house.karasuho.cabin',
      name: 'Cabana da Floresta Karasuho',
      region: 'region.arcane_forest',
      price: 3600,
      storageSlots: 45,
      fastTravel: true,
      tier: 'comfortable',
      features: ['cama', 'baú', 'tonel de respiração'],
      description: 'O ar dentro segura sua respiração mais tempo.',
    ),

    // Sukhenna — endgame.
    House(
      id: 'house.sukhenna.shrine',
      name: 'Santuário Amaldiçoado',
      region: 'region.cursed_lands',
      price: 48000,
      storageSlots: 200,
      fastTravel: true,
      tier: 'estate',
      features: [
        'cama', 'baú', 'altar amaldiçoado',
        'oficina', 'biblioteca proibida', 'portal de Expansão',
      ],
      description: 'A marca na sua pele acende quando você dorme.',
    ),

    // Estate suprema — endgame premium.
    House(
      id: 'house.eon.spire',
      name: 'Espiral de Éon',
      region: 'region.demon_keep',
      price: 250000,
      storageSlots: 500,
      fastTravel: true,
      tier: 'estate',
      features: [
        'cama', 'baú gigante', 'biblioteca completa',
        'oficina lendária', 'jardim de Éon', 'portal universal',
        'observatório', 'forja celestial',
      ],
      description: 'Apenas para Transcendentes. Os bardos vão cantar seu nome.',
    ),
  ];

  static const List<HotelRoom> hotelRooms = [
    HotelRoom(
      id: 'hotel.starthorn.inn_common',
      hotelName: 'Pousada Cova da Coruja',
      region: 'region.starthorn',
      tier: 'spartan',
      pricePerNight: 40,
      healPercent: 50,
      description: 'Cama dura, mas cura metade do HP/MP até de manhã.',
    ),
    HotelRoom(
      id: 'hotel.starthorn.inn_comfort',
      hotelName: 'Pousada Cova da Coruja',
      region: 'region.starthorn',
      tier: 'comfortable',
      pricePerNight: 120,
      healPercent: 100,
      buffs: ['rested'],
      description: 'Cama com pena de Garra-da-Estrela. Cura tudo + buff Descansado.',
    ),
    HotelRoom(
      id: 'hotel.velmoria.tower_suite',
      hotelName: 'Suíte da Torre',
      region: 'region.mage_tower',
      tier: 'royal',
      pricePerNight: 480,
      healPercent: 100,
      buffs: ['rested', 'inspired'],
      description: 'Vista para os 99 andares. Buff Inspirado dá +5 espírito.',
    ),
    HotelRoom(
      id: 'hotel.shirogane.dojo_loft',
      hotelName: 'Loft do Dojo',
      region: 'region.spirit_plane',
      tier: 'comfortable',
      pricePerNight: 220,
      healPercent: 100,
      buffs: ['rested', 'spirit_kin'],
      description: 'Ouça seu espírito sussurrar durante o sono.',
    ),
    HotelRoom(
      id: 'hotel.cursed.shrine_cell',
      hotelName: 'Cela do Santuário',
      region: 'region.cursed_lands',
      tier: 'comfortable',
      pricePerNight: 360,
      healPercent: 100,
      buffs: ['rested', 'eon_attuned'],
      description: 'Não é confortável. Mas seus stats sobem 8% temporariamente.',
    ),
  ];
}
