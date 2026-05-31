import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../lore/world_lore.dart';

class CodexScreen extends StatelessWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = WorldLore.all();
    return Scaffold(
      appBar: AppBar(title: const Text('Códex de Akyron')),
      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (ctx, i) {
          final e = entries[i];
          return ExpansionTile(
            title: Text(e.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AkyronTheme.goldEon,
                )),
            subtitle: Wrap(
              spacing: 4,
              children: [for (final t in e.tags) Chip(label: Text(t, style: const TextStyle(fontSize: 10)))],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(e.body, style: const TextStyle(height: 1.4)),
              ),
            ],
          );
        },
      ),
    );
  }
}
