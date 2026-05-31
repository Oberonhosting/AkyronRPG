import 'package:flutter/material.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/theme.dart';

class AudioSettingsScreen extends StatefulWidget {
  const AudioSettingsScreen({super.key});

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsScreenState();
}

class _AudioSettingsScreenState extends State<AudioSettingsScreen> {
  final _a = AudioDirector.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Áudio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Música'),
            subtitle: Text(_a.currentMood?.name ?? 'parado'),
            value: _a.musicEnabled,
            onChanged: (v) => setState(() => _a.setMusicEnabled(v)),
          ),
          ListTile(
            title: const Text('Volume da música'),
            subtitle: Slider(
              value: _a.musicVolume,
              onChanged: (v) => setState(() => _a.setMusicVolume(v)),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Efeitos sonoros (SFX)'),
            value: _a.sfxEnabled,
            onChanged: (v) => setState(() => _a.setSfxEnabled(v)),
          ),
          ListTile(
            title: const Text('Volume de SFX'),
            subtitle: Slider(
              value: _a.sfxVolume,
              onChanged: (v) => setState(() => _a.setSfxVolume(v)),
              onChangeEnd: (_) => _a.sfx(Sfx.uiClick),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pré-visualizar moods',
              style: TextStyle(
                color: AkyronTheme.goldEon,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in MusicMood.values)
                FilterChip(
                  label: Text(m.name),
                  selected: _a.currentMood == m,
                  onSelected: (_) async {
                    await _a.setMood(m);
                    if (mounted) setState(() {});
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Créditos da trilha',
              style: TextStyle(
                color: AkyronTheme.goldEon,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 8),
          for (final t in MusicCatalog.tracks.values)
            ListTile(
              dense: true,
              title: Text(t.title),
              subtitle: Text('${t.composer} — ${t.flavor}',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Text('${t.bpm > 0 ? '${t.bpm} bpm' : 'stinger'}',
                  style: const TextStyle(color: AkyronTheme.cyanSpirit)),
            ),
        ],
      ),
    );
  }
}
