import 'package:flutter/material.dart';

import 'enums.dart';

/// Customização visual do personagem. Tudo aqui é puramente cosmético — não
/// afeta stats — mas é renderizado pelo PlayerComponent e visível para
/// outros jogadores em servidores online.
class Appearance {
  Appearance({
    required this.gender,
    required this.faceShape,
    required this.hairStyle,
    required this.hairColor,
    required this.eyeStyle,
    required this.eyeColor,
    required this.skinTone,
    required this.height,
    required this.build,
    this.runicMarks = const [],
  });

  Gender gender;

  /// Índice na biblioteca de rostos (ex.: 0..15 por gênero).
  int faceShape;

  /// Estilo do cabelo (ex.: 'long_braid', 'short_spike', 'mage_long', ...).
  String hairStyle;
  Color hairColor;

  String eyeStyle;
  Color eyeColor;

  /// 0.0 mais claro → 1.0 mais escuro.
  double skinTone;

  /// Altura em cm (intervalo 150..210 por design).
  int height;

  /// Build corporal: 'slim', 'athletic', 'muscular', 'curvy', 'wiry'.
  String build;

  /// Marcas rúnicas opcionais — pequenos símbolos brilhantes na pele.
  List<String> runicMarks;

  Appearance copy() => Appearance(
        gender: gender,
        faceShape: faceShape,
        hairStyle: hairStyle,
        hairColor: hairColor,
        eyeStyle: eyeStyle,
        eyeColor: eyeColor,
        skinTone: skinTone,
        height: height,
        build: build,
        runicMarks: List.of(runicMarks),
      );

  Map<String, dynamic> toJson() => {
        'gender': gender.name,
        'face': faceShape,
        'hair': hairStyle,
        // ignore: deprecated_member_use
        'hairColor': hairColor.value,
        'eye': eyeStyle,
        // ignore: deprecated_member_use
        'eyeColor': eyeColor.value,
        'skin': skinTone,
        'height': height,
        'build': build,
        'marks': runicMarks,
      };

  factory Appearance.fromJson(Map<String, dynamic> j) => Appearance(
        gender: Gender.values.firstWhere(
          (g) => g.name == (j['gender'] ?? 'masculine'),
          orElse: () => Gender.masculine,
        ),
        faceShape: j['face'] ?? 0,
        hairStyle: j['hair'] ?? 'short_spike',
        hairColor: Color(j['hairColor'] ?? 0xFF221122),
        eyeStyle: j['eye'] ?? 'sharp',
        eyeColor: Color(j['eyeColor'] ?? 0xFF7A2EE0),
        skinTone: (j['skin'] ?? 0.4).toDouble(),
        height: j['height'] ?? 175,
        build: j['build'] ?? 'athletic',
        runicMarks: (j['marks'] as List?)?.cast<String>() ?? const [],
      );

  factory Appearance.defaultFor(Gender g) => Appearance(
        gender: g,
        faceShape: 0,
        hairStyle: g == Gender.feminine ? 'long_braid' : 'short_spike',
        hairColor: const Color(0xFF1A0F2B),
        eyeStyle: g == Gender.feminine ? 'soft' : 'sharp',
        eyeColor: const Color(0xFF7A2EE0),
        skinTone: 0.4,
        height: g == Gender.feminine ? 168 : 178,
        build: g == Gender.feminine ? 'curvy' : 'athletic',
      );
}

