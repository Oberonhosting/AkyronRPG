import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'ui/screens/audio_settings_screen.dart';
import 'ui/screens/codex_screen.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/widgets/rotate_device_overlay.dart';

class AkyronApp extends ConsumerWidget {
  const AkyronApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AkyronK.appName,
      debugShowCheckedModeBanner: false,
      theme: AkyronTheme.buildDark(),
      // RotateDeviceGate pede ao jogador para girar o aparelho em mobile;
      // em desktop/web ele é transparente.
      builder: (context, child) => RotateDeviceGate(child: child ?? const SizedBox.shrink()),
      home: const SplashScreen(),
      routes: {
        '/lore': (_) => const CodexScreen(),
        '/audio': (_) => const AudioSettingsScreen(),
      },
    );
  }
}
