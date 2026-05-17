# Akyron RPG — Gerador de áudio placeholder (Windows / PowerShell)
#
# Equivalente do generate_audio.sh. Requer ffmpeg no PATH.
#   choco install ffmpeg  (ou baixe de https://ffmpeg.org/download.html)
#
# Uso:
#   powershell -ExecutionPolicy Bypass -File scripts\generate_audio.ps1
#   ...                                              -Only sfx
#   ...                                              -Force

param(
  [ValidateSet('all','music','sfx','ambient')]
  [string]$Only = 'all',
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
  Write-Error "ffmpeg não encontrado no PATH. Instale: choco install ffmpeg"
  exit 1
}

$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path
$OUT  = Join-Path (Split-Path -Parent $ROOT) 'assets\audio'
New-Item -ItemType Directory -Force -Path "$OUT\music","$OUT\sfx","$OUT\ambient" | Out-Null

function Invoke-Ff {
  param([string]$Out, [string[]]$Args)
  if (Test-Path $Out -and -not $Force) {
    Write-Host "  ⏭  já existe: $(Split-Path $Out -Leaf)"
    return
  }
  $full = @('-y','-hide_banner','-loglevel','error') + $Args + @('-c:a','libvorbis','-q:a','4',$Out)
  & ffmpeg @full
  Write-Host "  ✓ $(Split-Path $Out -Leaf)"
}

# Reaproveita a mesma lógica do bash de forma mais simples — só os mais
# importantes. Para o catálogo COMPLETO recomenda-se usar generate_audio.sh
# via Git Bash / WSL no Windows.

Write-Host "Gerando subset essencial (use WSL ou Git Bash para o catálogo completo)..."

# Splash + menu
Invoke-Ff "$OUT\music\01_akyron_logo.ogg" @(
  '-f','lavfi','-i','sine=f=110:d=4',
  '-f','lavfi','-i','sine=f=220:d=4',
  '-filter_complex','[0][1]amix=inputs=2,aecho=0.6:0.6:600:0.4,afade=t=in:d=0.4,afade=t=out:st=3.5:d=0.5,volume=-10dB'
)
Invoke-Ff "$OUT\music\02_menu_eon.ogg" @(
  '-f','lavfi','-i','sine=f=220:d=30',
  '-f','lavfi','-i','sine=f=261.63:d=30',
  '-f','lavfi','-i','sine=f=329.63:d=30',
  '-filter_complex','[0][1][2]amix=inputs=3,tremolo=f=3:d=0.15,aecho=0.6:0.6:600:0.4,afade=t=in:d=0.4,afade=t=out:st=29:d=1,volume=-14dB'
)

# UI sfx
Invoke-Ff "$OUT\sfx\ui_click.ogg" @(
  '-f','lavfi','-i','anoisesrc=color=white:duration=0.1:amplitude=0.6',
  '-f','lavfi','-i','sine=f=880:d=0.1',
  '-filter_complex','[0][1]amix=inputs=2,afade=t=out:st=0:d=0.1,volume=-10dB'
)
Invoke-Ff "$OUT\sfx\level_up.ogg" @(
  '-f','lavfi','-i','sine=f=523.25:d=0.15',
  '-f','lavfi','-i','sine=f=659.25:d=0.15',
  '-f','lavfi','-i','sine=f=783.99:d=0.15',
  '-f','lavfi','-i','sine=f=1046.5:d=0.4',
  '-filter_complex','[0]adelay=0|0[a0];[1]adelay=100|100[a1];[2]adelay=200|200[a2];[3]adelay=300|300[a3];[a0][a1][a2][a3]amix=inputs=4:normalize=0,aecho=0.7:0.7:200:0.4,volume=-4dB,afade=t=out:st=0.7:d=0.2'
)

Write-Host ""
Write-Host "✅ Subset essencial gerado."
Write-Host "Para o catálogo COMPLETO (58 arquivos): use WSL ou Git Bash:"
Write-Host "    bash scripts/generate_audio.sh"
