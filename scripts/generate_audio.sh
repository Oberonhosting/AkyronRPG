#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
#  Akyron RPG — Gerador de áudio placeholder
# ─────────────────────────────────────────────────────────────────────
# Gera TODOS os 58 arquivos .ogg esperados pelo jogo, usando ffmpeg.
# É síntese procedural — não é uma trilha composta — mas dá ao jogo
# áudio funcional em cada momento. Depois você troca por gravações
# reais mantendo o mesmo nome de arquivo, e nada no código muda.
#
# REQUISITO: ffmpeg instalado.
#   Linux:   sudo apt install ffmpeg
#   macOS:   brew install ffmpeg
#   Windows: choco install ffmpeg  (ou use generate_audio.ps1)
#
# USO:
#   bash scripts/generate_audio.sh
#   bash scripts/generate_audio.sh --only sfx        # só os SFX
#   bash scripts/generate_audio.sh --only music
#   bash scripts/generate_audio.sh --only ambient
#   bash scripts/generate_audio.sh --force           # sobrescreve
# ─────────────────────────────────────────────────────────────────────

set -euo pipefail

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "❌ ffmpeg não encontrado. Instale primeiro."
  echo "    Linux:  sudo apt install ffmpeg"
  echo "    macOS:  brew install ffmpeg"
  echo "    Windows: choco install ffmpeg"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$SCRIPT_DIR/../assets/audio"
ONLY="all"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --only) ONLY="$2"; shift 2;;
    --force) FORCE=1; shift;;
    *) echo "Opção desconhecida: $1"; exit 1;;
  esac
done

mkdir -p "$OUT/music" "$OUT/sfx" "$OUT/ambient"

# ─────────────────────────── helpers ───────────────────────────
# Roda ffmpeg silenciosamente. Pula se já existe (a menos que --force).
ff() {
  local out="$1"; shift
  if [[ -f "$out" && "$FORCE" -eq 0 ]]; then
    echo "  ⏭  já existe: $(basename "$out")"
    return
  fi
  ffmpeg -y -hide_banner -loglevel error "$@" -c:a libvorbis -q:a 4 "$out"
  echo "  ✓ $(basename "$out")"
}

# Acorde = mistura de até 4 sines, formando um chord, com fade e reverb.
# args: dur freq1 freq2 freq3 freq4(opt) volDb out
synth_chord() {
  local dur="$1" f1="$2" f2="$3" f3="$4" f4="$5" vol="$6" out="$7"
  # Fade adaptativo: nunca maior que 20% da duração, mínimo 0.05s.
  local fade=$(awk -v d="$dur" 'BEGIN{f=d*0.2; if(f<0.05)f=0.05; if(f>0.5)f=0.5; printf "%.3f", f}')
  local fade_out_st=$(awk -v d="$dur" -v f="$fade" 'BEGIN{s=d-f; if(s<0)s=0; printf "%.3f", s}')
  local inputs=( -f lavfi -i "sine=f=$f1:d=$dur"
                 -f lavfi -i "sine=f=$f2:d=$dur"
                 -f lavfi -i "sine=f=$f3:d=$dur" )
  local filt="[0][1][2]amix=inputs=3:normalize=0"
  if [[ "$f4" != "0" ]]; then
    inputs+=( -f lavfi -i "sine=f=$f4:d=$dur" )
    filt="[0][1][2][3]amix=inputs=4:normalize=0"
  fi
  filt="$filt,aecho=0.6:0.6:600|900:0.4|0.2,tremolo=f=3:d=0.15,afade=t=in:d=$fade,afade=t=out:st=$fade_out_st:d=$fade,volume=${vol}dB"
  ff "$out" "${inputs[@]}" -filter_complex "$filt"
}

# Loop ambiental: noise filtrado + leve modulação.
# args: dur color(brown|pink|white) cutoffHz volDb out
synth_noise_loop() {
  local dur="$1" color="$2" cutoff="$3" vol="$4" out="$5"
  ff "$out" \
    -f lavfi -i "anoisesrc=color=$color:duration=$dur:amplitude=0.6" \
    -af "lowpass=f=$cutoff,highpass=f=80,tremolo=f=0.4:d=0.1,afade=t=in:d=1,afade=t=out:st=$(awk -v d="$dur" 'BEGIN{printf "%.2f", d-1}'):d=1,volume=${vol}dB"
}

# Stinger ascendente — varredura de frequência.
# args: dur freqStart freqEnd volDb out
synth_sweep() {
  local dur="$1" f0="$2" f1="$3" vol="$4" out="$5"
  ff "$out" \
    -f lavfi -i "aevalsrc=0.4*sin(2*PI*t*($f0+($f1-$f0)*t/$dur)):d=$dur" \
    -af "aecho=0.7:0.6:80|160:0.5|0.3,afade=t=in:d=0.05,afade=t=out:st=$(awk -v d="$dur" 'BEGIN{printf "%.2f", d-0.3}'):d=0.3,volume=${vol}dB"
}

# Pulse rítmico — usado em suspense.
# args: dur freq bpm volDb out
synth_pulse_loop() {
  local dur="$1" f="$2" bpm="$3" vol="$4" out="$5"
  local hz=$(awk -v b="$bpm" 'BEGIN{printf "%.3f", b/60.0}')
  ff "$out" \
    -f lavfi -i "sine=f=$f:d=$dur" \
    -af "tremolo=f=$hz:d=0.95,aecho=0.6:0.6:300|500:0.3|0.2,afade=t=in:d=1,afade=t=out:st=$(awk -v d="$dur" 'BEGIN{printf "%.2f", d-1}'):d=1,volume=${vol}dB"
}

# Hit/clique curto — burst de noise + sine.
# args: dur color freq volDb out
synth_hit() {
  local dur="$1" color="$2" freq="$3" vol="$4" out="$5"
  ff "$out" \
    -f lavfi -i "anoisesrc=color=$color:duration=$dur:amplitude=0.6" \
    -f lavfi -i "sine=f=$freq:d=$dur" \
    -filter_complex "[0][1]amix=inputs=2,afade=t=out:st=0:d=$dur,volume=${vol}dB"
}

# ─────────────────────────── MÚSICA ───────────────────────────
generate_music() {
  echo "🎼 Gerando trilhas..."

  # 01 — splash: sino solene + cordas
  synth_chord 4 110 220 329.63 0   -10 "$OUT/music/01_akyron_logo.ogg"

  # 02 — menu: piano-like arpeggio (la minor sustain)
  synth_chord 30 220 261.63 329.63 440 -14 "$OUT/music/02_menu_eon.ogg"

  # 03 — chapter sting: metálico + taiko
  synth_hit 2.5 brown 196 -6 "$OUT/music/03_chapter_sting.ogg"

  # 10 — village: leve, acústico (G major)
  synth_chord 30 196 246.94 293.66 0 -16 "$OUT/music/10_village_starthorn.ogg"

  # 11 — floresta arcana: pad com tribal (D minor)
  synth_chord 30 146.83 174.61 220 293.66 -16 "$OUT/music/11_forest_arcane.ogg"

  # 12 — torre dos magos: dissonante (C# + D + G)
  synth_chord 30 138.59 146.83 196 0 -16 "$OUT/music/12_mage_tower.ogg"

  # 13 — plano espiritual: etéreo agudo (E maj7)
  synth_chord 30 329.63 415.30 493.88 622.25 -18 "$OUT/music/13_spirit_plane.ogg"

  # 14 — terras amaldiçoadas: baixo distorcido
  synth_noise_loop 30 brown 200 -14 "$OUT/music/14_cursed_lands.ogg"

  # 15 — masmorra do rei: metal pesado (G♭ minor)
  synth_chord 30 92.50 110 138.59 174.61 -12 "$OUT/music/15_demon_keep.ogg"

  # 20 — suspense pulse: pulso de baixo
  synth_pulse_loop 30 110 92 -16 "$OUT/music/20_suspense_pulse.ogg"

  # 30 — combate regular: shōnen (F# minor uptempo)
  synth_pulse_loop 30 185 145 -12 "$OUT/music/30_combat_standard.ogg"

  # 31 — combate boss: agressivo (A minor)
  synth_pulse_loop 30 220 158 -10 "$OUT/music/31_combat_boss.ogg"

  # 32 — world boss: épico (C maj triumphant)
  synth_chord 30 261.63 329.63 392 523.25 -10 "$OUT/music/32_world_boss.ogg"

  # 40 — ultimate swell: stinger rising
  synth_sweep 3 220 1320 -6 "$OUT/music/40_ultimate_swell.ogg"

  # 50 — victory: fanfarra (C-E-G-C ascendente)
  ff "$OUT/music/50_victory_fanfare.ogg" \
    -f lavfi -i "sine=f=261.63:d=1" \
    -f lavfi -i "sine=f=329.63:d=1" \
    -f lavfi -i "sine=f=392:d=1" \
    -f lavfi -i "sine=f=523.25:d=3" \
    -filter_complex "[0]adelay=0|0[a0];[1]adelay=400|400[a1];[2]adelay=800|800[a2];[3]adelay=1200|1200[a3];[a0][a1][a2][a3]amix=inputs=4:normalize=0,aecho=0.7:0.7:600:0.4,afade=t=out:st=5.5:d=0.5,volume=-8dB"

  # 51 — defeat: piano descendente
  ff "$OUT/music/51_defeat_lament.ogg" \
    -f lavfi -i "sine=f=440:d=1" \
    -f lavfi -i "sine=f=329.63:d=1" \
    -f lavfi -i "sine=f=261.63:d=1" \
    -f lavfi -i "sine=f=220:d=2.5" \
    -filter_complex "[0]adelay=0|0[a0];[1]adelay=600|600[a1];[2]adelay=1300|1300[a2];[3]adelay=2100|2100[a3];[a0][a1][a2][a3]amix=inputs=4:normalize=0,aecho=0.6:0.6:800:0.5,afade=t=out:st=4.5:d=0.5,volume=-14dB"

  # 60 — shikai release: coro ascendente
  synth_sweep 5 165 660 -8 "$OUT/music/60_shikai_release.ogg"

  # 61 — bankai release: trovão + sino
  ff "$OUT/music/61_bankai_release.ogg" \
    -f lavfi -i "anoisesrc=color=brown:duration=7:amplitude=0.7" \
    -f lavfi -i "sine=f=65.41:d=7" \
    -f lavfi -i "sine=f=82.41:d=7" \
    -filter_complex "[0][1][2]amix=inputs=3,aecho=0.8:0.7:400|800:0.5|0.3,afade=t=in:d=0.1,afade=t=out:st=6:d=1,volume=-6dB"

  # 62 — domain expansion: silêncio + acorde esmagador
  ff "$OUT/music/62_domain_expansion.ogg" \
    -f lavfi -i "anullsrc=r=44100:cl=stereo:d=1.5" \
    -f lavfi -i "sine=f=58.27:d=5" \
    -f lavfi -i "sine=f=73.42:d=5" \
    -f lavfi -i "sine=f=87.31:d=5" \
    -filter_complex "[1][2][3]amix=inputs=3,aecho=0.8:0.8:300|600:0.6|0.4[chord];[0][chord]concat=n=2:v=0:a=1,volume=-6dB,afade=t=out:st=6:d=0.5"

  # 70 — awakening: heartbeat + rising
  ff "$OUT/music/70_awakening.ogg" \
    -f lavfi -i "sine=f=80:d=4" \
    -f lavfi -i "aevalsrc=0.5*sin(2*PI*t*(220+440*t/4)):d=4" \
    -filter_complex "[0]tremolo=f=2:d=0.95[heart];[heart][1]amix=inputs=2,aecho=0.6:0.5:200:0.3,afade=t=in:d=0.1,afade=t=out:st=3.5:d=0.5,volume=-8dB"

  # 80 — guild hall: mandolin (G major arpeggio sustain)
  synth_chord 30 196 246.94 293.66 392 -16 "$OUT/music/80_guild_hall.ogg"

  # 81 — battle pass reveal: glittery stinger
  synth_sweep 3.5 440 1760 -10 "$OUT/music/81_pass_reveal.ogg"
}

# ─────────────────────────── SFX ───────────────────────────
generate_sfx() {
  echo "💥 Gerando SFX..."

  # UI
  synth_hit 0.1 white 880  -10 "$OUT/sfx/ui_click.ogg"
  synth_hit 0.12 white 440 -10 "$OUT/sfx/ui_back.ogg"
  synth_hit 0.08 white 1320 -14 "$OUT/sfx/ui_hover.ogg"

  # Level up (arpeggio rising 4 notas)
  ff "$OUT/sfx/level_up.ogg" \
    -f lavfi -i "sine=f=523.25:d=0.15" \
    -f lavfi -i "sine=f=659.25:d=0.15" \
    -f lavfi -i "sine=f=783.99:d=0.15" \
    -f lavfi -i "sine=f=1046.50:d=0.4" \
    -filter_complex "[0]adelay=0|0[a0];[1]adelay=100|100[a1];[2]adelay=200|200[a2];[3]adelay=300|300[a3];[a0][a1][a2][a3]amix=inputs=4:normalize=0,aecho=0.7:0.7:200:0.4,volume=-4dB,afade=t=out:st=0.7:d=0.2"

  # Unlock skill — sino
  synth_chord 0.6 783.99 1046.50 1318.51 0 -8 "$OUT/sfx/unlock_skill.ogg"

  # Equip / unequip — swoosh
  synth_hit 0.25 pink 200 -8 "$OUT/sfx/equip.ogg"
  synth_hit 0.25 pink 150 -10 "$OUT/sfx/unequip.ogg"

  # Coin
  synth_chord 0.3 1318.51 1567.98 0 0 -8 "$OUT/sfx/coin.ogg"

  # Item drop
  synth_hit 0.2 brown 80 -6 "$OUT/sfx/item_drop.ogg"

  # Door
  synth_hit 0.8 brown 60 -8 "$OUT/sfx/door_open.ogg"

  # Spell — três níveis (low/mid/high) com sweep
  synth_sweep 0.4 220 660  -10 "$OUT/sfx/spell_low.ogg"
  synth_sweep 0.6 165 880  -8  "$OUT/sfx/spell_mid.ogg"
  synth_sweep 0.9 110 1760 -4  "$OUT/sfx/spell_high.ogg"

  # Sword
  synth_hit 0.3 white 1200 -6 "$OUT/sfx/sword_slash.ogg"
  synth_hit 0.25 white 1600 -8 "$OUT/sfx/sword_parry.ogg"

  # Hits
  synth_hit 0.18 brown 120 -4 "$OUT/sfx/punch_hit.ogg"
  synth_hit 0.20 brown 90  -6 "$OUT/sfx/enemy_hit.ogg"

  # Crit — sting de 2 tons
  ff "$OUT/sfx/crit_hit.ogg" \
    -f lavfi -i "anoisesrc=color=white:duration=0.3:amplitude=0.7" \
    -f lavfi -i "sine=f=1760:d=0.3" \
    -filter_complex "[0][1]amix=inputs=2,afade=t=out:st=0:d=0.3,volume=-3dB"

  # Enemy die — sweep descendente
  synth_sweep 0.8 440 80 -8 "$OUT/sfx/enemy_die.ogg"

  # Shield block
  synth_hit 0.2 white 800 -6 "$OUT/sfx/shield_block.ogg"

  # Status ticks
  synth_hit 0.3 pink 200 -14 "$OUT/sfx/burn_tick.ogg"
  synth_hit 0.3 pink 180 -16 "$OUT/sfx/poison_tick.ogg"
  synth_hit 0.4 white 2400 -10 "$OUT/sfx/freeze_apply.ogg"
  synth_pulse_loop 1.0 65 110 -12 "$OUT/sfx/cursed_hum.ogg"

  # Awakening flash
  synth_sweep 1.0 110 1320 -4 "$OUT/sfx/awakening_flash.ogg"

  # Social
  synth_chord 0.4 880 1108.73 0 0 -10 "$OUT/sfx/party_invite.ogg"
  synth_chord 0.25 1568 1864.66 0 0 -12 "$OUT/sfx/chat_ping.ogg"

  # World boss roar
  ff "$OUT/sfx/world_boss_roar.ogg" \
    -f lavfi -i "anoisesrc=color=brown:duration=2:amplitude=0.9" \
    -f lavfi -i "sine=f=55:d=2" \
    -filter_complex "[0][1]amix=inputs=2,aecho=0.8:0.7:300|600:0.5|0.3,afade=t=in:d=0.1,afade=t=out:st=1.7:d=0.3,volume=-2dB"
}

# ─────────────────────────── AMBIENT ───────────────────────────
generate_ambient() {
  echo "🌬️  Gerando ambientes..."

  # Bird — chirps simulados com sine quick
  ff "$OUT/ambient/bird.ogg" \
    -f lavfi -i "sine=f=2400:d=0.08" \
    -f lavfi -i "sine=f=2800:d=0.08" \
    -f lavfi -i "anullsrc=r=44100:cl=stereo:d=4" \
    -filter_complex "[0]adelay=200|200[c0];[1]adelay=350|350[c1];[c0][c1][2]amix=inputs=3,volume=-14dB" \
    -t 4

  synth_noise_loop 30 pink 4000 -18 "$OUT/ambient/fire_crackle.ogg"
  synth_noise_loop 30 pink 8000 -16 "$OUT/ambient/wind_high.ogg"

  # Cave drip — pings espaçados
  ff "$OUT/ambient/cave_drip.ogg" \
    -f lavfi -i "sine=f=1500:d=0.05" \
    -f lavfi -i "sine=f=1800:d=0.05" \
    -f lavfi -i "anullsrc=r=44100:cl=stereo:d=15" \
    -filter_complex "[0]adelay=2000|2000[d0];[1]adelay=7500|7500[d1];[d0][d1][2]amix=inputs=3,aecho=0.8:0.7:200:0.4,volume=-16dB" \
    -t 15

  synth_noise_loop 30 pink 6000 -12 "$OUT/ambient/rain.ogg"

  # Thunder — burst de noise brown
  ff "$OUT/ambient/thunder.ogg" \
    -f lavfi -i "anoisesrc=color=brown:duration=2.5:amplitude=0.95" \
    -af "lowpass=f=300,aecho=0.8:0.8:400|800:0.5|0.3,afade=t=in:d=0.1,afade=t=out:st=2:d=0.5,volume=-2dB"
}

# ─────────────────────────── RUN ───────────────────────────
case "$ONLY" in
  music) generate_music;;
  sfx) generate_sfx;;
  ambient) generate_ambient;;
  all)
    generate_music
    generate_sfx
    generate_ambient
    ;;
  *) echo "Valor inválido para --only: $ONLY"; exit 1;;
esac

echo ""
echo "✅ Pronto. Arquivos em: $OUT"
echo ""
echo "Para recriar do zero: bash scripts/generate_audio.sh --force"
echo "Para regerar uma seção: bash scripts/generate_audio.sh --only sfx --force"
