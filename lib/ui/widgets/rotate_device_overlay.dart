import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';

/// Wrapper que mostra um pedido animado de "vire o aparelho" quando o
/// dispositivo está em retrato. Só aplica em mobile — em desktop/web o
/// child passa direto.
///
/// Diferente de `setPreferredOrientations(...landscape)` (que força),
/// este pede educadamente. Quando o usuário rotaciona, o child aparece.
class RotateDeviceGate extends StatelessWidget {
  const RotateDeviceGate({super.key, required this.child});

  final Widget child;

  bool get _isMobile {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMobile) return child;
    return OrientationBuilder(
      builder: (ctx, orientation) {
        if (orientation == Orientation.landscape) return child;
        return const _RotatePrompt();
      },
    );
  }
}

class _RotatePrompt extends StatelessWidget {
  const _RotatePrompt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AkyronTheme.obsidian,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.screen_rotation,
                size: 96,
                color: AkyronTheme.goldEon,
              ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(
                    begin: -0.08,
                    end: 0.08,
                    duration: 1.2.seconds,
                    curve: Curves.easeInOut,
                  ),
              const SizedBox(height: 24),
              const Text(
                'GIRE O APARELHO',
                style: TextStyle(
                  color: AkyronTheme.goldEon,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'O mundo de Akyron foi feito para paisagem.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AkyronTheme.paperBeige),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
