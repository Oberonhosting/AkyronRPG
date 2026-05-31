#!/usr/bin/env bash
# Akyron RPG — Build em todas as plataformas que o seu OS suporta.

set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ flutter não encontrado."
  exit 1
fi

flutter pub get

# Detecta o sistema.
OS=$(uname -s)

echo ""
echo "▶ Build Web (universal)..."
flutter build web --release && echo "  ✅ build/web/"

case "$OS" in
  Linux)
    echo ""
    echo "▶ Build Android (precisa Android SDK)..."
    flutter build apk --release && echo "  ✅ build/app/outputs/flutter-apk/app-release.apk"

    echo ""
    echo "▶ Build Linux desktop..."
    flutter build linux --release && echo "  ✅ build/linux/x64/release/bundle/"
    ;;
  Darwin)
    echo ""
    echo "▶ Build iOS (precisa Xcode)..."
    flutter build ios --release --no-codesign && echo "  ✅ build/ios/"

    echo ""
    echo "▶ Build macOS desktop..."
    flutter build macos --release && echo "  ✅ build/macos/"

    echo ""
    echo "▶ Build Android (precisa Android SDK)..."
    flutter build apk --release && echo "  ✅ build/app/outputs/flutter-apk/app-release.apk"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    echo ""
    echo "▶ Build Windows desktop..."
    flutter build windows --release && echo "  ✅ build/windows/runner/Release/"

    echo ""
    echo "▶ Build Android (precisa Android SDK)..."
    flutter build apk --release && echo "  ✅ build/app/outputs/flutter-apk/app-release.apk"
    ;;
esac

echo ""
echo "🎉 Pronto."
