import 'dart:math';

import '../../models/enums.dart';

/// Sistema de clima dinâmico. Cada região tem um pool de presets; o clima
/// muda em intervalos e afeta alguns poderes (água ganha 10% na chuva,
/// fogo perde 10%, trovão crítico durante tempestade arcana, etc.).
class WeatherPreset {
  const WeatherPreset({
    required this.id,
    required this.label,
    required this.buffs,
    required this.debuffs,
  });

  final String id;
  final String label;
  final Map<Element, double> buffs;
  final Map<Element, double> debuffs;
}

class WeatherSystem {
  WeatherSystem({Random? rng}) : _rng = rng ?? Random();

  final Random _rng;
  WeatherPreset current = _presets.first;
  DateTime? _changedAt;

  void maybeRotate(List<String> regionPresets, {Duration after = const Duration(minutes: 4)}) {
    final now = DateTime.now();
    if (_changedAt != null && now.difference(_changedAt!) < after) return;
    final pool = _presets.where((p) => regionPresets.contains(p.id)).toList();
    if (pool.isEmpty) return;
    current = pool[_rng.nextInt(pool.length)];
    _changedAt = now;
  }

  double multiplierFor(Element e) {
    return (current.buffs[e] ?? 1.0) * (current.debuffs[e] ?? 1.0);
  }
}

const List<WeatherPreset> _presets = [
  WeatherPreset(id: 'clear', label: 'Céu Limpo', buffs: {Element.light: 1.05}, debuffs: {}),
  WeatherPreset(id: 'mist', label: 'Bruma', buffs: {Element.water: 1.1, Element.ice: 1.05}, debuffs: {Element.fire: 0.9}),
  WeatherPreset(id: 'rune_storm', label: 'Tempestade Rúnica', buffs: {Element.lightning: 1.2, Element.dark: 1.1}, debuffs: {Element.light: 0.85}),
  WeatherPreset(id: 'arcane_storm', label: 'Tormenta Arcana', buffs: {Element.dark: 1.15, Element.chaos: 1.2}, debuffs: {}),
  WeatherPreset(id: 'eclipse', label: 'Eclipse', buffs: {Element.dark: 1.25, Element.time: 1.1}, debuffs: {Element.light: 0.7}),
  WeatherPreset(id: 'blood_rain', label: 'Chuva Vermelha', buffs: {Element.blood: 1.3, Element.dark: 1.1}, debuffs: {Element.life: 0.8}),
  WeatherPreset(id: 'hellfire', label: 'Fogo do Mundo Inferior', buffs: {Element.fire: 1.3}, debuffs: {Element.ice: 0.7}),
  WeatherPreset(id: 'silence', label: 'Silêncio', buffs: {}, debuffs: {Element.sound: 0.5}),
  WeatherPreset(id: 'nebula', label: 'Nebulosa', buffs: {Element.space: 1.2, Element.time: 1.1}, debuffs: {}),
  WeatherPreset(id: 'breeze', label: 'Brisa', buffs: {Element.wind: 1.1}, debuffs: {}),
  WeatherPreset(id: 'dust', label: 'Pó Amaldiçoado', buffs: {Element.earth: 1.1}, debuffs: {}),
  WeatherPreset(id: 'indoor', label: 'Recinto Fechado', buffs: {}, debuffs: {}),
];
