import 'package:flutter/material.dart';

/// Descritor de uma região do mundo. O mapa Tiled real será carregado por
/// flame_tiled — aqui mantemos metadados e cor de "vibe" para o overlay.
class Region {
  const Region({
    required this.id,
    required this.title,
    required this.atmosphereTint,
    required this.minLevel,
    required this.weatherPresets,
    required this.spawnPool,
    this.musicTrack,
  });

  final String id;
  final String title;
  final Color atmosphereTint;
  final int minLevel;
  final List<String> weatherPresets;
  final List<String> spawnPool; // ids de inimigos para encontros aleatórios
  final String? musicTrack;
}

class WorldRegions {
  WorldRegions._();

  static const List<Region> all = [
    Region(
      id: 'region.starthorn',
      title: 'Vila de Espinho-de-Estrela',
      atmosphereTint: Color(0x22E8C547),
      minLevel: 1,
      weatherPresets: ['clear', 'breeze'],
      spawnPool: ['enemy.training_dummy'],
      musicTrack: 'akyron_village.ogg',
    ),
    Region(
      id: 'region.arcane_forest',
      title: 'Floresta Arcana',
      atmosphereTint: Color(0x227A2EE0),
      minLevel: 3,
      weatherPresets: ['clear', 'mist', 'arcane_storm'],
      spawnPool: ['enemy.rune_wolf', 'enemy.shadow_sprite'],
      musicTrack: 'arcane_forest.ogg',
    ),
    Region(
      id: 'region.mage_tower',
      title: 'Torre dos Magos',
      atmosphereTint: Color(0x22E0285A),
      minLevel: 8,
      weatherPresets: ['indoor', 'rune_storm'],
      spawnPool: ['enemy.constructed_golem', 'enemy.apprentice_lich'],
      musicTrack: 'tower_loop.ogg',
    ),
    Region(
      id: 'region.spirit_plane',
      title: 'Plano Espiritual',
      atmosphereTint: Color(0x224FF0E8),
      minLevel: 15,
      weatherPresets: ['nebula', 'silence'],
      spawnPool: ['enemy.lost_spirit', 'enemy.echo_blade'],
      musicTrack: 'spirit_plane.ogg',
    ),
    Region(
      id: 'region.cursed_lands',
      title: 'Terras Amaldiçoadas',
      atmosphereTint: Color(0x22B02FE0),
      minLevel: 25,
      weatherPresets: ['blood_rain', 'eclipse', 'dust'],
      spawnPool: ['enemy.cursed_husk', 'enemy.veil_walker'],
      musicTrack: 'cursed_loop.ogg',
    ),
    Region(
      id: 'region.demon_keep',
      title: 'Masmorra do Rei Demônio',
      atmosphereTint: Color(0x22E0285A),
      minLevel: 50,
      weatherPresets: ['hellfire', 'silence'],
      spawnPool: ['enemy.demon_general', 'enemy.broken_seal_disciple'],
      musicTrack: 'demon_keep.ogg',
    ),
  ];

  static Region byId(String id) =>
      all.firstWhere((r) => r.id == id, orElse: () => all.first);
}
