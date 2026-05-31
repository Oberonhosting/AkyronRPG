// Constantes globais do Akyron RPG.

class AkyronK {
  AkyronK._();

  static const String appName = 'Akyron RPG';
  static const String appTagline = 'A fratura virou caminho.';
  static const String version = '0.1.0';

  // Limites de design.
  static const int maxPartySize = 4;
  static const int maxGuildSize = 30;
  static const int maxFriends = 200;

  // Sistema de turnos.
  static const int turnTimerSeconds = 30;
  static const int comboWindowMs = 800;

  // Progressão.
  static const int maxLevel = 120;
  static const int awakeningHpThresholdPct = 25; // 25% de HP ativa despertar.

  // Save.
  static const String saveDbFileName = 'akyron_save.db';
  static const int saveSchemaVersion = 1;

  // Rede.
  static const Duration netTimeout = Duration(seconds: 10);
  static const int maxServerPlayers = 200;
  static const int defaultPort = 28960;
}
