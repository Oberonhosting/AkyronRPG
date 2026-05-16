import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'ui/screens/codex_screen.dart';
import 'ui/screens/splash_screen.dart';

class AkyronApp extends ConsumerWidget {
  const AkyronApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AkyronK.appName,
      debugShowCheckedModeBanner: false,
      theme: AkyronTheme.buildDark(),
      home: const SplashScreen(),
      routes: {
        '/lore': (_) => const CodexScreen(),
      },
    );
  }
}
