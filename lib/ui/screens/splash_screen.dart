import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../audio/audio_director.dart';
import '../../audio/track_catalog.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AudioDirector.instance.setMood(MusicMood.splash);
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      AudioDirector.instance.setMood(MusicMood.mainMenu);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AkyronTheme.obsidian,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 96, color: AkyronTheme.goldEon)
                .animate()
                .scale(begin: const Offset(0.4, 0.4), end: const Offset(1, 1), duration: 800.ms, curve: Curves.elasticOut)
                .shimmer(duration: 1.6.seconds, color: AkyronTheme.crimsonAura),
            const SizedBox(height: 24),
            Text(
              AkyronK.appName,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: AkyronTheme.goldEon,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 700.ms),
            const SizedBox(height: 8),
            Text(
              AkyronK.appTagline,
              style: const TextStyle(
                color: AkyronTheme.paperBeige,
                fontStyle: FontStyle.italic,
              ),
            ).animate().fadeIn(delay: 900.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
