import 'package:flutter/material.dart';

/// Display metadata (label, icon, color) for a slang category key.
class SlangCategory {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const SlangCategory({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  /// Ordered list of all known categories in the dataset.
  static const List<SlangCategory> all = [
    SlangCategory(
      key: 'idioms',
      label: 'Idiomy',
      icon: Icons.auto_awesome,
      color: Color(0xFF6C5CE7),
    ),
    SlangCategory(
      key: 'gen_z',
      label: 'Gen Z',
      icon: Icons.bolt,
      color: Color(0xFFE84393),
    ),
    SlangCategory(
      key: 'internet',
      label: 'Internet',
      icon: Icons.public,
      color: Color(0xFF0984E3),
    ),
    SlangCategory(
      key: 'social_media',
      label: 'Sociální sítě',
      icon: Icons.tag,
      color: Color(0xFF00B894),
    ),
    SlangCategory(
      key: 'gaming',
      label: 'Hraní',
      icon: Icons.sports_esports,
      color: Color(0xFFE17055),
    ),
    SlangCategory(
      key: 'dating',
      label: 'Randění',
      icon: Icons.favorite,
      color: Color(0xFFFD79A8),
    ),
    SlangCategory(
      key: 'daily_speech',
      label: 'Běžná mluva',
      icon: Icons.chat_bubble_outline,
      color: Color(0xFF00CEC9),
    ),
    SlangCategory(
      key: 'business',
      label: 'Byznys',
      icon: Icons.business_center,
      color: Color(0xFF2D3436),
    ),
    SlangCategory(
      key: 'workplace',
      label: 'Práce',
      icon: Icons.work_outline,
      color: Color(0xFF636E72),
    ),
    SlangCategory(
      key: 'phrasal_verbs',
      label: 'Frázová slovesa',
      icon: Icons.link,
      color: Color(0xFFA29BFE),
    ),
    SlangCategory(
      key: 'british_slang',
      label: 'Britský slang',
      icon: Icons.castle,
      color: Color(0xFFD63031),
    ),
    SlangCategory(
      key: 'american_slang',
      label: 'Americký slang',
      icon: Icons.flag,
      color: Color(0xFF0652DD),
    ),
  ];

  static const SlangCategory _fallback = SlangCategory(
    key: 'other',
    label: 'Ostatní',
    icon: Icons.label_outline,
    color: Color(0xFF747D8C),
  );

  /// Returns category metadata for [key], or a generic fallback.
  static SlangCategory byKey(String key) {
    for (final c in all) {
      if (c.key == key) return c;
    }
    return _fallback;
  }
}
