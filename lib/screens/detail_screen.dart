import 'package:flutter/material.dart';

import '../app.dart';
import '../models/slang_category.dart';
import '../models/slang_entry.dart';
import '../services/favorites_service.dart';

/// Full details for a single slang entry.
class DetailScreen extends StatelessWidget {
  final SlangEntry entry;
  const DetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = SlangCategory.byKey(entry.category);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              final isFav = FavoritesService.instance.isFavorite(entry.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? theme.colorScheme.primary : null,
                onPressed: () => FavoritesService.instance.toggle(entry.id),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _Header(entry: entry, category: category),
          const SizedBox(height: 24),
          ValueListenableBuilder<bool>(
            valueListenable: literalModeNotifier,
            builder: (context, literalMode, _) {
              // The "correct" style: primary color, lightbulb, not crossed out.
              // The "literal" style: tertiary color, translate icon, crossed out.
              // In literal mode the doslovný překlad takes the "correct" style
              // (and top spot) while the skutečný význam looks like the throwaway
              // literal one.
              final correctCard = _MeaningCard(
                label: 'Doslovný překlad',
                text: entry.literalCzech,
                icon: Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
              );
              final literalStyledCard = _MeaningCard(
                label: 'Skutečný význam',
                text: entry.actualMeaningCzech,
                icon: Icons.translate,
                color: theme.colorScheme.tertiary,
                crossedOut: true,
              );

              final defaultLiteralCard = _MeaningCard(
                label: 'Doslovný překlad',
                text: entry.literalCzech,
                icon: Icons.translate,
                color: theme.colorScheme.tertiary,
                crossedOut: true,
              );
              final defaultActualCard = _MeaningCard(
                label: 'Skutečný význam',
                text: entry.actualMeaningCzech,
                icon: Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
              );

              final cards = literalMode
                  ? [correctCard, literalStyledCard]
                  : [defaultLiteralCard, defaultActualCard];
              return Column(
                children: [
                  cards[0],
                  const SizedBox(height: 12),
                  cards[1],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Příklady použití', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _ExampleCard(en: entry.exampleEn, cz: entry.exampleCz),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SlangEntry entry;
  final SlangCategory category;
  const _Header({required this.entry, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.color.withValues(alpha: 0.85),
            category.color.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                category.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            entry.english,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeaningCard extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final Color color;
  final bool crossedOut;

  const _MeaningCard({
    required this.label,
    required this.text,
    required this.icon,
    required this.color,
    this.crossedOut = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration:
                  crossedOut ? TextDecoration.lineThrough : TextDecoration.none,
              color: crossedOut ? theme.colorScheme.onSurfaceVariant : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String en;
  final String cz;
  const _ExampleCard({required this.en, required this.cz});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('EN', style: _tagStyle(theme)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  en,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CZ', style: _tagStyle(theme)),
              const SizedBox(width: 10),
              Expanded(child: Text(cz, style: theme.textTheme.bodyLarge)),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle? _tagStyle(ThemeData theme) => theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w800,
      );
}
