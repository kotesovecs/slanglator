import 'package:flutter/material.dart';

import '../data/slang_repository.dart';
import '../models/slang_entry.dart';
import '../services/favorites_service.dart';
import '../widgets/slang_card.dart';
import 'detail_screen.dart';

/// Shows the user's favorited entries, reacting to favorite changes.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final ids = FavoritesService.instance.ids;
        if (ids.isEmpty) {
          return const _EmptyFavorites();
        }
        return FutureBuilder<List<SlangEntry>>(
          future: SlangRepository.instance.byIds(ids),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final entries = snapshot.data ?? const [];
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final entry = entries[i];
                return SlangCard(
                  entry: entry,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(entry: entry),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border,
              size: 56, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Zatím žádné oblíbené', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Klepni na srdíčko u libovolného výrazu a uloží se sem.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
