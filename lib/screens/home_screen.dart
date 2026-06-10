import 'dart:math';

import 'package:flutter/material.dart';

import '../app.dart';
import '../data/slang_repository.dart';
import '../services/favorites_service.dart';
import 'about_screen.dart';
import 'browse_screen.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

/// Root scaffold with bottom navigation between the main sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _titles = ['Slanglator', 'Oblíbené'];

  final _random = Random();

  int _logoTapCount = 0;
  DateTime? _lastLogoTap;

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastLogoTap == null ||
        now.difference(_lastLogoTap!) > const Duration(milliseconds: 800)) {
      _logoTapCount = 0;
    }
    _lastLogoTap = now;
    _logoTapCount++;

    if (_logoTapCount >= 6) {
      _logoTapCount = 0;
      literalModeNotifier.value = !literalModeNotifier.value;
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              literalModeNotifier.value
                  ? 'Doslovný režim zapnut'
                  : 'Doslovný režim vypnut',
            ),
          ),
        );
    }
  }

  Future<void> _openRandom() async {
    final all = await SlangRepository.instance.loadAll();
    if (all.isEmpty || !mounted) return;
    final entry = all[_random.nextInt(all.length)];
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailScreen(entry: entry)),
    );
  }

  void _toggleTheme() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onLogoTap,
          child: Text(
            _titles[_index],
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Náhodný výraz',
            icon: const Icon(Icons.shuffle),
            onPressed: _openRandom,
          ),
          IconButton(
            tooltip: 'Přepnout motiv',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
          IconButton(
            tooltip: 'O aplikaci',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [BrowseScreen(), FavoritesScreen()],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: FavoritesService.instance,
        builder: (context, _) {
          final favCount = FavoritesService.instance.count;
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Procházet',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: favCount > 0,
                  label: Text('$favCount'),
                  child: const Icon(Icons.favorite_border),
                ),
                selectedIcon: Badge(
                  isLabelVisible: favCount > 0,
                  label: Text('$favCount'),
                  child: const Icon(Icons.favorite),
                ),
                label: 'Oblíbené',
              ),
            ],
          );
        },
      ),
    );
  }
}
