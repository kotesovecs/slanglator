import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:slanglator/models/slang_entry.dart';
import 'package:slanglator/screens/detail_screen.dart';

void main() {
  testWidgets('Detail screen shows term and meanings', (tester) async {
    const entry = SlangEntry(
      id: 1,
      english: 'break a leg',
      literalCzech: 'zlom si nohu',
      actualMeaningCzech: 'hodně štěstí',
      category: 'idioms',
      exampleEn: 'Break a leg tonight!',
      exampleCz: 'Hodně štěstí dnes večer!',
    );

    await tester.pumpWidget(
      const MaterialApp(home: DetailScreen(entry: entry)),
    );

    expect(find.text('break a leg'), findsOneWidget);
    expect(find.text('zlom si nohu'), findsOneWidget);
    expect(find.text('hodně štěstí'), findsOneWidget);
  });

  test('SlangEntry.matches is case-insensitive across fields', () {
    const entry = SlangEntry(
      id: 2,
      english: 'cool',
      literalCzech: 'chladný',
      actualMeaningCzech: 'skvělý',
      category: 'idioms',
      exampleEn: '',
      exampleCz: '',
    );

    expect(entry.matches('COOL'), isTrue);
    expect(entry.matches('skvěl'), isTrue);
    expect(entry.matches('xyz'), isFalse);
  });
}
