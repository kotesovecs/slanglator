/// A single slang term with its literal and actual Czech meaning.
class SlangEntry {
  final int id;
  final String english;
  final String literalCzech;
  final String actualMeaningCzech;
  final String category;
  final String exampleEn;
  final String exampleCz;

  const SlangEntry({
    required this.id,
    required this.english,
    required this.literalCzech,
    required this.actualMeaningCzech,
    required this.category,
    required this.exampleEn,
    required this.exampleCz,
  });

  factory SlangEntry.fromJson(Map<String, dynamic> json) => SlangEntry(
        id: json['id'] as int,
        english: json['english'] as String? ?? '',
        literalCzech: json['literalCzech'] as String? ?? '',
        actualMeaningCzech: json['actualMeaningCzech'] as String? ?? '',
        category: json['category'] as String? ?? 'other',
        exampleEn: json['exampleEn'] as String? ?? '',
        exampleCz: json['exampleCz'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'english': english,
        'literalCzech': literalCzech,
        'actualMeaningCzech': actualMeaningCzech,
        'category': category,
        'exampleEn': exampleEn,
        'exampleCz': exampleCz,
      };

  /// Whether any searchable field contains [query] (case-insensitive).
  bool matches(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return true;
    return english.toLowerCase().contains(q) ||
        literalCzech.toLowerCase().contains(q) ||
        actualMeaningCzech.toLowerCase().contains(q);
  }
}
