import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';
import '../../systems/progression/leveling.dart';

class LevelUpOverlay extends StatelessWidget {
  const LevelUpOverlay({
    super.key,
    required this.result,
    required this.onDismiss,
  });

  final LevelUpResult result;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final bonuses = result.statBonuses.entries
        .where((e) => e.value > 0)
        .map((e) => '+${e.value} ${e.key.toUpperCase()}')
        .join('   ');

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.78),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('LEVEL UP',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: AkyronTheme.goldEon,
                        letterSpacing: 8,
                      ))
                  .animate()
                  .scale(begin: const Offset(0.6, 0.6), end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut)
                  .shimmer(duration: 1.seconds, color: Colors.white),
              const SizedBox(height: 12),
              Text('Nível ${result.newLevel}  •  Rank ${result.newRank.name.toUpperCase()}',
                  style: const TextStyle(fontSize: 22, color: AkyronTheme.paperBeige)),
              const SizedBox(height: 16),
              Text(bonuses,
                  style: const TextStyle(
                    color: AkyronTheme.cyanSpirit,
                    letterSpacing: 1.4,
                    fontSize: 16,
                  )),
              const SizedBox(height: 28),
              const Text('toque para continuar',
                  style: TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}
