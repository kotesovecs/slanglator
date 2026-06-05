import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the set of favorited entry ids and persists them locally.
///
/// Exposed as a [ChangeNotifier] so the UI can rebuild via [ListenableBuilder].
class FavoritesService extends ChangeNotifier {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  static const String _prefsKey = 'favorite_ids';

  final Set<int> _ids = {};
  bool _loaded = false;

  Set<int> get ids => Set.unmodifiable(_ids);
  int get count => _ids.length;
  bool get isLoaded => _loaded;

  bool isFavorite(int id) => _ids.contains(id);

  /// Loads persisted favorites from disk. Safe to call multiple times.
  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? const [];
    _ids
      ..clear()
      ..addAll(stored.map(int.tryParse).whereType<int>());
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (!_ids.add(id)) {
      _ids.remove(id);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _ids.map((e) => e.toString()).toList(),
    );
  }
}
