import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/id_generator.dart';
import '../../core/theme.dart';
import '../../models/appearance.dart';
import '../../models/character.dart';
import '../../models/enums.dart';
import '../../models/inventory.dart';
import '../../models/equipment.dart';
import '../../systems/powers/breathing_system.dart';
import '../../systems/powers/chakra_system.dart';
import '../../systems/powers/cursed_energy_system.dart';
import '../../systems/powers/grimoire_system.dart';
import '../../systems/powers/nen_system.dart';
import '../../systems/powers/zanpakuto_system.dart';
import '../../systems/powers/power_base.dart';
import '../../data/catalogs/ability_catalog.dart';

/// Tela de criação de personagem — gênero, customização, classe inicial.
class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameCtrl = TextEditingController(text: 'Yami');
  Gender _gender = Gender.masculine;
  PowerSystem _system = PowerSystem.grimoire;
  Element _element = Element.fire;
  Color _hair = const Color(0xFF1A0F2B);
  Color _eye = AkyronTheme.violetArcane;
  String _hairStyle = 'short_spike';
  double _skinTone = 0.4;
  int _height = 178;
  String _build = 'athletic';

  late Appearance _appearance = Appearance.defaultFor(_gender);

  void _syncAppearance() {
    _appearance = Appearance(
      gender: _gender,
      faceShape: 0,
      hairStyle: _hairStyle,
      hairColor: _hair,
      eyeStyle: _gender == Gender.feminine ? 'soft' : 'sharp',
      eyeColor: _eye,
      skinTone: _skinTone,
      height: _height,
      build: _build,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  PowerCore _buildPower() {
    switch (_system) {
      case PowerSystem.grimoire:
        final leaves = 3;
        final core = GrimoireCore(element: _element, leaves: leaves);
        for (final a in AbilityCatalog.bySystem(PowerSystem.grimoire)
            .where((a) => a.element == _element)
            .take(2)) {
          core.learn(a);
        }
        return core;
      case PowerSystem.zanpakuto:
        final core = ZanpakutoCore(
          element: _element,
          spiritName: _generateSpiritName(),
          spiritPersonality: 'Cética mas leal',
        );
        for (final a in AbilityCatalog.bySystem(PowerSystem.zanpakuto).take(2)) {
          core.abilities.add(a);
        }
        return core;
      case PowerSystem.chakra:
        final core = ChakraCore(element: _element);
        for (final a in AbilityCatalog.bySystem(PowerSystem.chakra)
            .where((a) => a.element == _element)
            .take(2)) {
          core.abilities.add(a);
        }
        return core;
      case PowerSystem.breathing:
        final style = _breathingStyleFor(_element);
        final core = BreathingCore(style: style);
        for (final a in AbilityCatalog.bySystem(PowerSystem.breathing)
            .where((a) => a.element == style.element)
            .take(2)) {
          core.abilities.add(a);
        }
        return core;
      case PowerSystem.nen:
        final core = NenCore(type: NenType.enhancement, element: _element);
        for (final a in AbilityCatalog.bySystem(PowerSystem.nen).take(2)) {
          core.abilities.add(a);
        }
        return core;
      case PowerSystem.cursed:
        final core = CursedEnergyCore(
          innateTechnique: _generateInnateTechniqueName(),
          element: _element,
        );
        for (final a in AbilityCatalog.bySystem(PowerSystem.cursed).take(2)) {
          core.abilities.add(a);
        }
        return core;
    }
  }

  String _generateSpiritName() {
    final names = ['Tsukibarai', 'Yorukage', 'Hyōrinmaru', 'Kazenui', 'Senrai'];
    return names[Random().nextInt(names.length)];
  }

  String _generateInnateTechniqueName() {
    final names = [
      'Caminho do Vazio Curto',
      'Espelho Quebrado',
      'Corte da Última Marca',
      'Mão que Conta Segredos',
      'Olho que Pesa',
    ];
    return names[Random().nextInt(names.length)];
  }

  BreathingStyle _breathingStyleFor(Element e) => switch (e) {
        Element.water => BreathingStyle.water,
        Element.fire => BreathingStyle.flame,
        Element.lightning => BreathingStyle.thunder,
        Element.earth => BreathingStyle.stone,
        Element.wind => BreathingStyle.wind,
        Element.ice => BreathingStyle.mist,
        Element.light => BreathingStyle.sun,
        _ => BreathingStyle.water,
      };

  Character _commit() {
    _syncAppearance();
    final inv = Inventory();
    inv.add('head.ninja_band_leaf');
    inv.add('top.runic_shirt');
    inv.add('bot.combat_pants');
    inv.add('foot.medieval_boots');
    inv.add('aura.golden_dust');
    if (_gender == Gender.feminine) {
      inv.add('top.battle_dress');
      inv.add('bot.split_skirt');
    } else {
      inv.add('top.leather_corset_m');
    }

    final c = Character(
      playerId: PlayerId.fromName(_nameCtrl.text),
      displayName: _nameCtrl.text.trim().isEmpty ? 'Wanderer' : _nameCtrl.text.trim(),
      appearance: _appearance,
      power: _buildPower(),
      inventory: inv,
    );
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criação de Personagem')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader('Identidade'),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome do despertador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              _SectionHeader('Gênero'),
              SegmentedButton<Gender>(
                segments: const [
                  ButtonSegment(value: Gender.masculine, label: Text('Masculino')),
                  ButtonSegment(value: Gender.feminine, label: Text('Feminino')),
                ],
                selected: {_gender},
                onSelectionChanged: (s) => setState(() {
                  _gender = s.first;
                  _hairStyle = _gender == Gender.feminine ? 'long_braid' : 'short_spike';
                  _build = _gender == Gender.feminine ? 'curvy' : 'athletic';
                  _height = _gender == Gender.feminine ? 168 : 178;
                }),
              ),
              const SizedBox(height: 16),
              _SectionHeader('Aparência'),
              _colorPickerRow('Cor do cabelo', _hair, (c) => setState(() => _hair = c)),
              _colorPickerRow('Cor dos olhos', _eye, (c) => setState(() => _eye = c)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final s in _hairOptions(_gender))
                    ChoiceChip(
                      label: Text(s),
                      selected: _hairStyle == s,
                      onSelected: (_) => setState(() => _hairStyle = s),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tom de pele'),
                  Expanded(
                    child: Slider(
                      value: _skinTone,
                      onChanged: (v) => setState(() => _skinTone = v),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Altura (cm)'),
                  Expanded(
                    child: Slider(
                      value: _height.toDouble(),
                      min: 150, max: 210,
                      divisions: 60,
                      label: '$_height',
                      onChanged: (v) => setState(() => _height = v.round()),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  for (final b in _buildOptions(_gender))
                    ChoiceChip(
                      label: Text(b),
                      selected: _build == b,
                      onSelected: (_) => setState(() => _build = b),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionHeader('Classe inicial'),
              ...PowerSystem.values.map((s) => RadioListTile<PowerSystem>(
                    value: s,
                    groupValue: _system,
                    onChanged: (v) => setState(() => _system = v!),
                    title: Text(s.displayName),
                    subtitle: Text(_classBlurb(s)),
                  )),
              const SizedBox(height: 8),
              _SectionHeader('Elemento / Afinidade'),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  for (final e in _allowedElements(_system))
                    ChoiceChip(
                      label: Text(e.name),
                      selected: _element == e,
                      onSelected: (_) => setState(() => _element = e),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_commit()),
                  child: const Text('Despertar Personagem'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorPickerRow(String label, Color current, ValueChanged<Color> onPick) {
    const palette = [
      Color(0xFF1A0F2B), Color(0xFF4A1F8A), Color(0xFFE8C547),
      Color(0xFF7A2EE0), Color(0xFF4FF0E8), Color(0xFFE0285A),
      Color(0xFFB8C0D0), Color(0xFF63E07A), Color(0xFF2A0F2A),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: Wrap(
              spacing: 6,
              children: [
                for (final c in palette)
                  GestureDetector(
                    onTap: () => onPick(c),
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: c,
                        border: Border.all(
                          color: current == c ? AkyronTheme.goldEon : Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _hairOptions(Gender g) => g == Gender.feminine
      ? const ['long_braid', 'long_wavy', 'pixie', 'twin_tails', 'mage_long']
      : const ['short_spike', 'mid_messy', 'long_tied', 'mohawk', 'mage_long'];

  List<String> _buildOptions(Gender g) => g == Gender.feminine
      ? const ['slim', 'athletic', 'curvy', 'wiry']
      : const ['slim', 'athletic', 'muscular', 'wiry'];

  List<Element> _allowedElements(PowerSystem s) => switch (s) {
        PowerSystem.grimoire => Element.values,
        PowerSystem.chakra => const [
            Element.fire, Element.water, Element.earth, Element.wind, Element.lightning,
          ],
        PowerSystem.breathing => const [
            Element.water, Element.fire, Element.lightning, Element.earth,
            Element.wind, Element.ice, Element.light,
          ],
        PowerSystem.zanpakuto => const [
            Element.dark, Element.ice, Element.fire, Element.wind, Element.light, Element.water,
          ],
        PowerSystem.nen => const [Element.life],
        PowerSystem.cursed => const [Element.dark, Element.blood, Element.chaos],
      };

  String _classBlurb(PowerSystem s) => switch (s) {
        PowerSystem.grimoire => 'Velmoria. Magia escrita em livro próprio.',
        PowerSystem.zanpakuto => 'Shirogane. Espada com espírito que conversa.',
        PowerSystem.chakra => 'Konsho. Selos manuais e jutsus elementais.',
        PowerSystem.breathing => 'Karasuho. Formas numeradas de espada.',
        PowerSystem.nen => 'Yorokai. Aura visível com afinidade descoberta.',
        PowerSystem.cursed => 'Sukhenna. Técnica inata + Expansão de Território.',
      };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AkyronTheme.goldEon,
          fontSize: 14,
          letterSpacing: 3,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
