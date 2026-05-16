import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';

/// Texto cinemático estilo mangá que aparece quando o jogador grita o nome
/// de uma magia/jutsu/forma.
class BattleCryOverlay extends StatelessWidget {
  const BattleCryOverlay({
    super.key,
    required this.text,
    this.isUltimate = false,
  });

  final String text;
  final bool isUltimate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Transform.rotate(
            angle: -0.08,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isUltimate ? 56 : 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: isUltimate ? AkyronTheme.goldEon : Colors.white,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 18, offset: Offset(0, 0)),
                  Shadow(color: AkyronTheme.crimsonAura, blurRadius: 24, offset: const Offset(2, 2)),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate(key: ValueKey(text))
        .fadeIn(duration: 120.ms)
        .scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.05, 1.05),
          curve: Curves.elasticOut,
          duration: 600.ms,
        )
        .then(delay: 700.ms)
        .fadeOut(duration: 300.ms);
  }
}
