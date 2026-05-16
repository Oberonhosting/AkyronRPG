import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';

/// Overlay que aparece ao entrar em uma região nova — "CAPÍTULO XII: …".
class ChapterIntro extends StatelessWidget {
  const ChapterIntro({
    super.key,
    required this.chapter,
    required this.title,
    required this.subtitle,
    required this.onDone,
  });

  final String chapter;
  final String title;
  final String subtitle;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDone,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(chapter.toUpperCase(),
                      style: const TextStyle(
                        color: AkyronTheme.goldEon,
                        fontSize: 16,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w700,
                      ))
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 12),
              Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ))
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 800.ms),
              const SizedBox(height: 8),
              Text(subtitle,
                      style: const TextStyle(
                        color: AkyronTheme.paperBeige,
                        fontStyle: FontStyle.italic,
                      ))
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
