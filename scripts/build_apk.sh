#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
#  Akyron RPG — Build APK Android (local)
# ─────────────────────────────────────────────────────────────────────
# Pré-requisitos:
#   - Flutter SDK 3.22+ no PATH        (https://docs.flutter.dev/get-started/install)
#   - Java JDK 17+                     (sudo apt install openjdk-17-jdk)
#   - Android SDK + cmdline-tools      (instalado pelo Android Studio
#                                       ou pelo sdkmanager)
#
# Saída: build/app/outputs/flutter-apk/app-release.apk
# ─────────────────────────────────────────────────────────────────────

set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ flutter não encontrado no PATH."
  echo "   Instale: https://docs.flutter.dev/get-started/install"
  exit 1
fi

cd "$(dirname "$0")/.."

MODE="${1:-release}"   # release | debug | profile

echo "▶ flutter doctor (validação)..."
flutter doctor || true

echo ""
echo "▶ flutter pub get..."
flutter pub get

echo ""
echo "▶ flutter build apk --$MODE..."
flutter build apk "--$MODE"

APK="build/app/outputs/flutter-apk/app-$MODE.apk"
if [[ -f "$APK" ]]; then
  echo ""
  echo "✅ APK gerado: $APK"
  echo "   Tamanho: $(du -h "$APK" | awk '{print $1}')"
  echo ""
  echo "Para instalar via adb:"
  echo "   adb install -r $APK"
else
  echo "❌ Build falhou. Veja o log acima."
  exit 1
fi
