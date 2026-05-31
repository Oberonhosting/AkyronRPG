// Catálogo de trilhas e SFX do Akyron RPG.
//
// Cada faixa tem um propósito narrativo. O `AudioDirector` escolhe a
// trilha certa baseado no contexto (região, HP do jogador, ultimate
// ativada, boss mundial em curso, etc).
//
// Os arquivos físicos vivem em `assets/audio/{music,sfx,ambient}/` e
// devem ser .ogg (recomendado — leve e suportado em todas as plataformas
// que o Flame audio cobre). Caso o arquivo não exista no disco, o
// AudioDirector falha silenciosamente — o jogo continua sem áudio.

/// Mood/intenção da música. O Director resolve mood → arquivo.
enum MusicMood {
  splash,           // logotipo inicial
  mainMenu,         // menu principal
  chapterIntro,     // overlay "CAPÍTULO X"
  exploreVillage,   // vila tranquila
  exploreForest,    // floresta arcana
  exploreTower,     // torre dos magos — místico
  exploreSpirit,    // plano espiritual — etéreo
  exploreCursed,    // terras amaldiçoadas — sombrio
  exploreDemon,     // masmorra do rei demônio — pesado
  suspense,         // baixa HP fora de combate / encontro iminente
  combatRegular,    // combate normal
  combatBoss,       // boss de área
  combatWorldBoss,  // boss mundial sincronizado
  ultimate,         // sobrepõe momentaneamente quando ultimate dispara
  victory,          // vitória em combate
  defeat,           // derrota em combate
  cutsceneShikai,   // liberação de Shikai
  cutsceneBankai,   // liberação de Bankai
  cutsceneDomain,   // Expansão de Território
  awakening,        // jogador despertou em HP crítico
  guildHall,        // sede de guild / cidade segura
  battlePassReveal, // tela do battle pass
}

class MusicTrack {
  const MusicTrack({
    required this.mood,
    required this.asset,
    required this.title,
    required this.composer,
    required this.bpm,
    required this.loop,
    this.volume = 0.6,
    this.fadeInMs = 800,
    this.flavor = '',
  });

  final MusicMood mood;
  final String asset;       // caminho relativo a assets/audio/
  final String title;
  final String composer;    // crédito visível no menu de áudio
  final int bpm;
  final bool loop;
  final double volume;
  final int fadeInMs;
  final String flavor;      // descrição artística — aparece no códex
}

/// Catálogo de trilhas. Use AudioDirector para tocar — não toque direto.
class MusicCatalog {
  MusicCatalog._();

  static const Map<MusicMood, MusicTrack> tracks = {
    MusicMood.splash: MusicTrack(
      mood: MusicMood.splash,
      asset: 'music/01_akyron_logo.ogg',
      title: 'Akyron — Logotipo',
      composer: 'Akyron OST',
      bpm: 70,
      loop: false,
      volume: 0.7,
      flavor: 'Sino solene, naipe de cordas seguram a respiração.',
    ),
    MusicMood.mainMenu: MusicTrack(
      mood: MusicMood.mainMenu,
      asset: 'music/02_menu_eon.ogg',
      title: 'Menu — Éon Adormecido',
      composer: 'Akyron OST',
      bpm: 84,
      loop: true,
      volume: 0.55,
      flavor: 'Piano em loop sobre pad arcano. Convida e ameaça ao mesmo tempo.',
    ),
    MusicMood.chapterIntro: MusicTrack(
      mood: MusicMood.chapterIntro,
      asset: 'music/03_chapter_sting.ogg',
      title: 'Sting — Novo Capítulo',
      composer: 'Akyron OST',
      bpm: 100,
      loop: false,
      volume: 0.8,
      fadeInMs: 200,
      flavor: 'Acento metálico, taiko duplo e coro grave.',
    ),
    MusicMood.exploreVillage: MusicTrack(
      mood: MusicMood.exploreVillage,
      asset: 'music/10_village_starthorn.ogg',
      title: 'Espinho-de-Estrela',
      composer: 'Akyron OST',
      bpm: 90,
      loop: true,
      volume: 0.5,
      flavor: 'Acústico e leve, flauta + bandolim, sensação de "casa".',
    ),
    MusicMood.exploreForest: MusicTrack(
      mood: MusicMood.exploreForest,
      asset: 'music/11_forest_arcane.ogg',
      title: 'Floresta Arcana',
      composer: 'Akyron OST',
      bpm: 78,
      loop: true,
      volume: 0.5,
      flavor: 'Pad de sintetizador antigo + percussão tribal lenta.',
    ),
    MusicMood.exploreTower: MusicTrack(
      mood: MusicMood.exploreTower,
      asset: 'music/12_mage_tower.ogg',
      title: 'Torre dos 99 Andares',
      composer: 'Akyron OST',
      bpm: 95,
      loop: true,
      volume: 0.55,
      flavor: 'Cravo dissonante, sinos invertidos, suspense vertical.',
    ),
    MusicMood.exploreSpirit: MusicTrack(
      mood: MusicMood.exploreSpirit,
      asset: 'music/13_spirit_plane.ogg',
      title: 'Onde os Espíritos Andam',
      composer: 'Akyron OST',
      bpm: 60,
      loop: true,
      volume: 0.45,
      flavor: 'Coros femininos etéreos, vento e vidro.',
    ),
    MusicMood.exploreCursed: MusicTrack(
      mood: MusicMood.exploreCursed,
      asset: 'music/14_cursed_lands.ogg',
      title: 'Sukhenna em Ruínas',
      composer: 'Akyron OST',
      bpm: 76,
      loop: true,
      volume: 0.55,
      flavor: 'Baixo distorcido, sopros graves, lamento ao fundo.',
    ),
    MusicMood.exploreDemon: MusicTrack(
      mood: MusicMood.exploreDemon,
      asset: 'music/15_demon_keep.ogg',
      title: 'Masmorra do Rei Demônio',
      composer: 'Akyron OST',
      bpm: 130,
      loop: true,
      volume: 0.6,
      flavor: 'Metal sinfônico, taiko pesado, coro masculino.',
    ),
    MusicMood.suspense: MusicTrack(
      mood: MusicMood.suspense,
      asset: 'music/20_suspense_pulse.ogg',
      title: 'Algo Perto',
      composer: 'Akyron OST',
      bpm: 92,
      loop: true,
      volume: 0.5,
      flavor: 'Pulso de baixo + corda aguda em harmônico — algo te observa.',
    ),
    MusicMood.combatRegular: MusicTrack(
      mood: MusicMood.combatRegular,
      asset: 'music/30_combat_standard.ogg',
      title: 'Choque de Auras',
      composer: 'Akyron OST',
      bpm: 145,
      loop: true,
      volume: 0.65,
      fadeInMs: 400,
      flavor: 'Guitarra elétrica + violino, batida shōnen clássica.',
    ),
    MusicMood.combatBoss: MusicTrack(
      mood: MusicMood.combatBoss,
      asset: 'music/31_combat_boss.ogg',
      title: 'Boss — A Marca Aberta',
      composer: 'Akyron OST',
      bpm: 158,
      loop: true,
      volume: 0.7,
      fadeInMs: 400,
      flavor: 'Coro latino sobre orquestra agressiva.',
    ),
    MusicMood.combatWorldBoss: MusicTrack(
      mood: MusicMood.combatWorldBoss,
      asset: 'music/32_world_boss.ogg',
      title: 'O Devorador Velado',
      composer: 'Akyron OST',
      bpm: 168,
      loop: true,
      volume: 0.75,
      fadeInMs: 500,
      flavor: 'Tema épico — todos os jogadores ouvem o mesmo loop.',
    ),
    MusicMood.ultimate: MusicTrack(
      mood: MusicMood.ultimate,
      asset: 'music/40_ultimate_swell.ogg',
      title: 'Ultimate Swell',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.85,
      fadeInMs: 50,
      flavor: 'Stinger de 3s para cobrir o grito da ultimate.',
    ),
    MusicMood.victory: MusicTrack(
      mood: MusicMood.victory,
      asset: 'music/50_victory_fanfare.ogg',
      title: 'Fanfarra de Vitória',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.7,
      flavor: 'Metais brilhantes, dura ~6 s.',
    ),
    MusicMood.defeat: MusicTrack(
      mood: MusicMood.defeat,
      asset: 'music/51_defeat_lament.ogg',
      title: 'Lamento — Reanimando na Vila',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.55,
      flavor: 'Piano só, frase descendente.',
    ),
    MusicMood.cutsceneShikai: MusicTrack(
      mood: MusicMood.cutsceneShikai,
      asset: 'music/60_shikai_release.ogg',
      title: 'Liberação — Shikai',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.85,
      flavor: 'Coro ascendente + acorde sustentado, ~5 s.',
    ),
    MusicMood.cutsceneBankai: MusicTrack(
      mood: MusicMood.cutsceneBankai,
      asset: 'music/61_bankai_release.ogg',
      title: 'BANKAI',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.9,
      flavor: 'Trovão + sino quebrado + coro grave, ~7 s.',
    ),
    MusicMood.cutsceneDomain: MusicTrack(
      mood: MusicMood.cutsceneDomain,
      asset: 'music/62_domain_expansion.ogg',
      title: 'Expansão de Território',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.9,
      flavor: 'Tudo silencia, e então um único acorde sufoca a arena.',
    ),
    MusicMood.awakening: MusicTrack(
      mood: MusicMood.awakening,
      asset: 'music/70_awakening.ogg',
      title: 'Despertar em HP Crítico',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.85,
      flavor: 'Coração batendo + corda subindo + flash de metal.',
    ),
    MusicMood.guildHall: MusicTrack(
      mood: MusicMood.guildHall,
      asset: 'music/80_guild_hall.ogg',
      title: 'Salão da Guild',
      composer: 'Akyron OST',
      bpm: 88,
      loop: true,
      volume: 0.45,
      flavor: 'Tema acolhedor com mandolina e percussão suave.',
    ),
    MusicMood.battlePassReveal: MusicTrack(
      mood: MusicMood.battlePassReveal,
      asset: 'music/81_pass_reveal.ogg',
      title: 'Battle Pass — Reveal',
      composer: 'Akyron OST',
      bpm: 0,
      loop: false,
      volume: 0.7,
      flavor: 'Stinger curto, brilhante, com glitter sintético.',
    ),
  };
}

/// Sons one-shot.
enum Sfx {
  uiClick,
  uiBack,
  uiHover,
  levelUp,
  unlockSkill,
  equip,
  unequip,
  coinPickup,
  itemDrop,
  doorOpen,
  spellCastLow,
  spellCastMid,
  spellCastHigh,
  swordSlash,
  swordParry,
  punchHit,
  enemyHit,
  critHit,
  enemyDie,
  shieldBlock,
  burnTick,
  poisonTick,
  freezeApply,
  cursedHum,
  awakeningFlash,
  partyInvite,
  chatPing,
  worldBossRoar,
  ambientBird,
  ambientFireCrackle,
  ambientWindHigh,
  ambientCaveDrip,
  rain,
  thunder,
}

class SfxAsset {
  const SfxAsset({required this.id, required this.asset, this.volume = 0.7});
  final Sfx id;
  final String asset;
  final double volume;
}

class SfxCatalog {
  SfxCatalog._();

  static const Map<Sfx, SfxAsset> sfx = {
    Sfx.uiClick: SfxAsset(id: Sfx.uiClick, asset: 'sfx/ui_click.ogg', volume: 0.5),
    Sfx.uiBack: SfxAsset(id: Sfx.uiBack, asset: 'sfx/ui_back.ogg', volume: 0.5),
    Sfx.uiHover: SfxAsset(id: Sfx.uiHover, asset: 'sfx/ui_hover.ogg', volume: 0.35),
    Sfx.levelUp: SfxAsset(id: Sfx.levelUp, asset: 'sfx/level_up.ogg', volume: 0.9),
    Sfx.unlockSkill: SfxAsset(id: Sfx.unlockSkill, asset: 'sfx/unlock_skill.ogg', volume: 0.8),
    Sfx.equip: SfxAsset(id: Sfx.equip, asset: 'sfx/equip.ogg'),
    Sfx.unequip: SfxAsset(id: Sfx.unequip, asset: 'sfx/unequip.ogg'),
    Sfx.coinPickup: SfxAsset(id: Sfx.coinPickup, asset: 'sfx/coin.ogg', volume: 0.6),
    Sfx.itemDrop: SfxAsset(id: Sfx.itemDrop, asset: 'sfx/item_drop.ogg'),
    Sfx.doorOpen: SfxAsset(id: Sfx.doorOpen, asset: 'sfx/door_open.ogg'),
    Sfx.spellCastLow: SfxAsset(id: Sfx.spellCastLow, asset: 'sfx/spell_low.ogg'),
    Sfx.spellCastMid: SfxAsset(id: Sfx.spellCastMid, asset: 'sfx/spell_mid.ogg'),
    Sfx.spellCastHigh: SfxAsset(id: Sfx.spellCastHigh, asset: 'sfx/spell_high.ogg', volume: 0.9),
    Sfx.swordSlash: SfxAsset(id: Sfx.swordSlash, asset: 'sfx/sword_slash.ogg', volume: 0.8),
    Sfx.swordParry: SfxAsset(id: Sfx.swordParry, asset: 'sfx/sword_parry.ogg'),
    Sfx.punchHit: SfxAsset(id: Sfx.punchHit, asset: 'sfx/punch_hit.ogg', volume: 0.8),
    Sfx.enemyHit: SfxAsset(id: Sfx.enemyHit, asset: 'sfx/enemy_hit.ogg'),
    Sfx.critHit: SfxAsset(id: Sfx.critHit, asset: 'sfx/crit_hit.ogg', volume: 0.95),
    Sfx.enemyDie: SfxAsset(id: Sfx.enemyDie, asset: 'sfx/enemy_die.ogg', volume: 0.85),
    Sfx.shieldBlock: SfxAsset(id: Sfx.shieldBlock, asset: 'sfx/shield_block.ogg'),
    Sfx.burnTick: SfxAsset(id: Sfx.burnTick, asset: 'sfx/burn_tick.ogg', volume: 0.45),
    Sfx.poisonTick: SfxAsset(id: Sfx.poisonTick, asset: 'sfx/poison_tick.ogg', volume: 0.45),
    Sfx.freezeApply: SfxAsset(id: Sfx.freezeApply, asset: 'sfx/freeze_apply.ogg'),
    Sfx.cursedHum: SfxAsset(id: Sfx.cursedHum, asset: 'sfx/cursed_hum.ogg', volume: 0.6),
    Sfx.awakeningFlash: SfxAsset(id: Sfx.awakeningFlash, asset: 'sfx/awakening_flash.ogg', volume: 0.95),
    Sfx.partyInvite: SfxAsset(id: Sfx.partyInvite, asset: 'sfx/party_invite.ogg'),
    Sfx.chatPing: SfxAsset(id: Sfx.chatPing, asset: 'sfx/chat_ping.ogg', volume: 0.5),
    Sfx.worldBossRoar: SfxAsset(id: Sfx.worldBossRoar, asset: 'sfx/world_boss_roar.ogg', volume: 1.0),
    Sfx.ambientBird: SfxAsset(id: Sfx.ambientBird, asset: 'ambient/bird.ogg', volume: 0.4),
    Sfx.ambientFireCrackle: SfxAsset(id: Sfx.ambientFireCrackle, asset: 'ambient/fire_crackle.ogg', volume: 0.4),
    Sfx.ambientWindHigh: SfxAsset(id: Sfx.ambientWindHigh, asset: 'ambient/wind_high.ogg', volume: 0.4),
    Sfx.ambientCaveDrip: SfxAsset(id: Sfx.ambientCaveDrip, asset: 'ambient/cave_drip.ogg', volume: 0.4),
    Sfx.rain: SfxAsset(id: Sfx.rain, asset: 'ambient/rain.ogg', volume: 0.5),
    Sfx.thunder: SfxAsset(id: Sfx.thunder, asset: 'ambient/thunder.ogg', volume: 0.85),
  };
}
