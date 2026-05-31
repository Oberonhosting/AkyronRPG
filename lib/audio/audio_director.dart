import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../game/world/region.dart';
import '../game/world/weather.dart';
import '../models/character.dart';
import '../models/enums.dart';
import 'track_catalog.dart';

/// Orquestra a trilha sonora do jogo.
///
/// Princípios:
/// - Apenas UMA música de fundo tocando por vez (gerenciada via
///   FlameAudio.bgm).
/// - Tocar stingers/ultimates **sobrepõe** brevemente via [playStinger]
///   sem interromper o BGM permanentemente — quando o stinger acaba,
///   retomamos o que estava antes.
/// - Falha silenciosa: se o arquivo .ogg não está presente, o jogo
///   continua sem crashar (apenas loga no debug).
///
/// Uso:
/// ```dart
/// await AudioDirector.instance.init();
/// AudioDirector.instance.setMood(MusicMood.exploreVillage);
/// AudioDirector.instance.playStinger(MusicMood.ultimate);
/// AudioDirector.instance.sfx(Sfx.swordSlash);
/// ```
class AudioDirector {
  AudioDirector._();
  static final AudioDirector instance = AudioDirector._();

  bool _initialized = false;
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;

  MusicMood? _currentMood;
  MusicMood? _suspendedMood; // mood temporariamente substituído por stinger

  /// Inicializa o subsistema de áudio. Pode ser chamado mais de uma vez.
  Future<void> init() async {
    if (_initialized) return;
    try {
      FlameAudio.bgm.initialize();
      // Pré-carrega só o essencial — o resto carrega sob demanda.
      await _safe(() => FlameAudio.audioCache.loadAll([
            'music/02_menu_eon.ogg',
            'sfx/ui_click.ogg',
          ]));
      _initialized = true;
    } catch (e) {
      _log('init failed: $e');
    }
  }

  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  MusicMood? get currentMood => _currentMood;

  void setMusicEnabled(bool v) {
    _musicEnabled = v;
    if (!v) FlameAudio.bgm.stop();
  }

  void setSfxEnabled(bool v) => _sfxEnabled = v;

  void setMusicVolume(double v) {
    _musicVolume = v.clamp(0.0, 1.0);
    _safe(() => FlameAudio.bgm.audioPlayer.setVolume(_musicVolume));
  }

  void setSfxVolume(double v) => _sfxVolume = v.clamp(0.0, 1.0);

  /// Decide a trilha de exploração apropriada para a região atual e o
  /// estado do jogador (HP baixo, despertar ativo, etc.).
  MusicMood pickExploreMood(Character c) {
    final hp = c.baseStats.hp;
    final maxHp = c.baseStats.maxHp;
    if (maxHp > 0 && hp / maxHp < 0.18) {
      return MusicMood.suspense;
    }
    return switch (c.region) {
      'region.starthorn' => MusicMood.exploreVillage,
      'region.arcane_forest' => MusicMood.exploreForest,
      'region.mage_tower' => MusicMood.exploreTower,
      'region.spirit_plane' => MusicMood.exploreSpirit,
      'region.cursed_lands' => MusicMood.exploreCursed,
      'region.demon_keep' => MusicMood.exploreDemon,
      _ => MusicMood.exploreVillage,
    };
  }

  /// Aplica buff de música para clima dramático (eclipse → suspense
  /// mesmo em vila tranquila).
  MusicMood applyWeatherOverride(MusicMood base, WeatherSystem weather, Region region) {
    final id = weather.current.id;
    if (id == 'eclipse' || id == 'blood_rain') return MusicMood.suspense;
    if (id == 'hellfire' && region.minLevel >= 25) return MusicMood.exploreDemon;
    return base;
  }

  /// Troca de música de fundo. Faz crossfade simples.
  Future<void> setMood(MusicMood mood) async {
    if (_currentMood == mood) return;
    final track = MusicCatalog.tracks[mood];
    if (track == null) return;
    _currentMood = mood;
    if (!_musicEnabled) return;

    await _safe(() async {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.play(
        track.asset,
        volume: track.volume * _musicVolume,
      );
    });
  }

  /// Toca um stinger (cutscene ou ultimate). Pausa o BGM atual, toca o
  /// stinger uma vez, depois volta ao mood anterior.
  Future<void> playStinger(MusicMood mood) async {
    final track = MusicCatalog.tracks[mood];
    if (track == null) return;
    if (!_musicEnabled) return;

    _suspendedMood = _currentMood;
    await _safe(() async {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.play(
        track.asset,
        volume: track.volume * _musicVolume,
      );
    });
    // Stingers não loopam — retomamos o anterior após ~estimativa.
    final ms = _estimatedDurationMs(mood);
    Timer(Duration(milliseconds: ms), () {
      if (_suspendedMood != null) {
        final back = _suspendedMood!;
        _suspendedMood = null;
        _currentMood = null;
        setMood(back);
      }
    });
  }

  /// Toca um SFX one-shot.
  void sfx(Sfx id) {
    if (!_sfxEnabled) return;
    final s = SfxCatalog.sfx[id];
    if (s == null) return;
    _safe(() => FlameAudio.play(s.asset, volume: s.volume * _sfxVolume));
  }

  /// Para tudo (usado ao sair para o desktop ou ao sleep mobile).
  Future<void> stopAll() async {
    _currentMood = null;
    _suspendedMood = null;
    await _safe(() => FlameAudio.bgm.stop());
  }

  // Aproximação grosseira do tempo de stinger por mood — usada apenas
  // para decidir quando voltar pro BGM principal.
  int _estimatedDurationMs(MusicMood mood) => switch (mood) {
        MusicMood.ultimate => 3200,
        MusicMood.chapterIntro => 2800,
        MusicMood.cutsceneShikai => 5000,
        MusicMood.cutsceneBankai => 7000,
        MusicMood.cutsceneDomain => 6500,
        MusicMood.awakening => 4000,
        MusicMood.victory => 6000,
        MusicMood.defeat => 5000,
        MusicMood.battlePassReveal => 3500,
        _ => 3000,
      };

  Future<T?> _safe<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      _log('audio op failed: $e');
      return null;
    }
  }

  void _log(String msg) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[AudioDirector] $msg');
    }
  }
}
