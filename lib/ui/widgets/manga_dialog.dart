import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Caixa de diálogo estilo mangá — borda grossa, retrato à esquerda,
/// texto à direita, "rabicho" do balão apontando para o personagem.
class MangaDialog extends StatelessWidget {
  const MangaDialog({
    super.key,
    required this.speaker,
    required this.text,
    this.portrait,
    this.actions = const [],
  });

  final String speaker;
  final String text;
  final Widget? portrait;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AkyronTheme.paperBeige,
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black87, offset: Offset(4, 4)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (portrait != null)
                Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: AkyronTheme.goldEon, width: 2),
                  ),
                  child: portrait,
                ),
              Expanded(
                child: Text(
                  speaker,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.black87, height: 1.3),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: actions),
          ],
        ],
      ),
    );
  }
}
