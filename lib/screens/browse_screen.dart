import 'package:flutter/material.dart';

import '../data/slang_repository.dart';
import '../models/slang_category.dart';
import '../models/slang_entry.dart';
import '../widgets/slang_card.dart';
import 'detail_screen.dart';

/// Searchable, filterable list of all slang entries.
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedCategory;

  late Future<List<SlangEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = SlangRepository.instance.loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SlangEntry> _filter(List<SlangEntry> all) {
    return all.where((e) {
      final matchesCategory =
          _selectedCategory == null || e.category == _selectedCategory;
      return matchesCategory && e.matches(_query);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SlangEntry>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Chyba načítání: ${snapshot.error}'));
        }
        final all = snapshot.data ?? const [];
        final results = _filter(all);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Hledat slang, význam…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            _CategoryFilter(
              selected: _selectedCategory,
              onSelected: (key) => setState(() => _selectedCategory = key),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${results.length} výsledků',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? const _EmptyResults()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final entry = results[i];
                        return SlangCard(
                          entry: entry,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(entry: entry),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _CategoryFilter({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'Vše',
            icon: Icons.apps,
            color: Theme.of(context).colorScheme.primary,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final c in SlangCategory.all)
            _FilterChip(
              label: c.label,
              icon: c.icon,
              color: c.color,
              selected: selected == c.key,
              onTap: () => onSelected(c.key),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 18,
          color: selected ? Colors.white : color,
        ),
        label: Text(label),
        labelStyle: TextStyle(
          color: selected ? Colors.white : null,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: color.withValues(alpha: 0.10),
        selectedColor: color,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off,
              size: 56, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Nic nenalezeno', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Zkus jiné hledání nebo kategorii.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
