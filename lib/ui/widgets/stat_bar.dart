import 'package:flutter/material.dart';

/// Barra de status (HP/MP/Chakra/Energia) com ticks pixel-art.
class StatBar extends StatelessWidget {
  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    this.height = 12,
    this.showNumbers = true,
  });

  final String label;
  final int value;
  final int max;
  final Color color;
  final double height;
  final bool showNumbers;

  @override
  Widget build(BuildContext context) {
    final pct = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                )),
            const Spacer(),
            if (showNumbers)
              Text('$value / $max',
                  style: const TextStyle(fontSize: 11)),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: pct,
            child: Container(color: color),
          ),
        ),
      ],
    );
  }
}
