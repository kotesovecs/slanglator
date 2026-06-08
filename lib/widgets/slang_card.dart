import 'package:flutter/material.dart';

import '../app.dart';
import '../models/slang_category.dart';
import '../models/slang_entry.dart';
import '../services/favorites_service.dart';

/// Compact card showing a slang term and its actual meaning in a list.
class SlangCard extends StatelessWidget {
  final SlangEntry entry;
  final VoidCallback onTap;

  const SlangCard({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = SlangCategory.byKey(entry.category);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(category.icon, color: category.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.english,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ValueListenableBuilder<bool>(
                      valueListenable: literalModeNotifier,
                      builder: (context, literalMode, _) {
                        return Text(
                          literalMode
                              ? entry.literalCzech
                              : entry.actualMeaningCzech,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle:
                                literalMode ? FontStyle.italic : FontStyle.normal,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: category.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _FavoriteButton(id: entry.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final int id;
  const _FavoriteButton({required this.id});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final isFav = FavoritesService.instance.isFavorite(id);
        return IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          color: isFav ? Theme.of(context).colorScheme.primary : null,
          tooltip: isFav ? 'Odebrat z oblíbených' : 'Přidat do oblíbených',
          onPressed: () => FavoritesService.instance.toggle(id),
        );
      },
    );
  }
}
