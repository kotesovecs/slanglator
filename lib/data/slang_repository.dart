import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/slang_entry.dart';

/// Loads and caches the slang dataset bundled as an asset.
class SlangRepository {
  SlangRepository._();
  static final SlangRepository instance = SlangRepository._();

  static const String _assetPath = 'assets/data/slang_dataset.json';

  List<SlangEntry>? _cache;

  /// Returns all entries, loading from the asset on first call.
  Future<List<SlangEntry>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = json.decode(raw) as List<dynamic>;
    _cache = decoded
        .map((e) => SlangEntry.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _cache!;
  }

  /// Returns the entries matching the given [ids], preserving dataset order.
  Future<List<SlangEntry>> byIds(Set<int> ids) async {
    final all = await loadAll();
    return all.where((e) => ids.contains(e.id)).toList(growable: false);
  }
}
