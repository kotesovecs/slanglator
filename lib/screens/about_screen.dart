import 'package:flutter/material.dart';

import '../data/slang_repository.dart';
import '../models/slang_category.dart';

/// Simple about / info page describing the app and dataset stats.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('O aplikaci')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.translate,
                    size: 40,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Slanglator', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Anglický slang česky',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Slanglator ti ukáže rozdíl mezi doslovným překladem a skutečným '
            'významem anglických slangových výrazů a idiomů – s příklady '
            'použití a rozdělením do kategorií.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FutureBuilder(
            future: SlangRepository.instance.loadAll(),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return _StatRow(
                items: [
                  _Stat(label: 'Výrazů', value: '$count'),
                  _Stat(
                    label: 'Kategorií',
                    value: '${SlangCategory.all.length}',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Stat {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});
}

class _StatRow extends StatelessWidget {
  final List<_Stat> items;
  const _StatRow({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (final item in items)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    item.value,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.label, style: theme.textTheme.labelLarge),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
