# Slanglator

A Flutter app that translates and explains **English slang, idioms and phrasal verbs for Czech speakers**. Every entry shows the *literal* word-for-word Czech translation next to the *actual* meaning, so you can see why a phrase like _"break a leg"_ doesn't really mean "zlom si nohu".

## Features

- **1100+ curated entries** across 12 categories (idioms, phrasal verbs, everyday speech, Gen Z, internet, social media, gaming, dating, workplace, business, British and American slang).
- **Literal vs. real meaning** — each term shows the literal Czech translation and what it actually means.
- **Example sentences** in English with Czech translation.
- **Browse & search** by text or category.
- **Favorites** — save entries for later (persisted locally via `shared_preferences`).
- **Detail view** for each term.

## Tech stack

- [Flutter](https://flutter.dev/) (Dart SDK `^3.8.1`)
- `shared_preferences` for local favorites storage
- Slang data bundled as a JSON asset (`assets/data/slang_dataset.json`)

## Project structure

```
lib/
  app.dart                     # App widget & routing
  main.dart                    # Entry point
  data/slang_repository.dart   # Loads & caches the JSON dataset
  models/                      # SlangEntry, SlangCategory
  screens/                     # home, browse, detail, favorites, about
  services/favorites_service.dart
  theme/app_theme.dart
  widgets/slang_card.dart
assets/data/slang_dataset.json # The slang dataset
tools/                         # Python generator for the dataset
```

## Getting started

Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed, then:

```bash
flutter pub get
flutter run
```

To run the tests:

```bash
flutter test
```

## Regenerating the dataset

The dataset is generated from curated, per-category Python source files in `tools/`. Each entry is a tuple of `(english, literalCzech, actualMeaningCzech, exampleEn, exampleCz)`.

To edit the data, change the relevant `tools/data_*.py` file and regenerate:

```bash
python3 tools/generate_dataset.py
```

This rewrites `assets/data/slang_dataset.json`, assigns sequential IDs, and skips duplicate English terms.

## Data model

Each entry has the following shape:

```json
{
  "id": 1,
  "english": "break a leg",
  "literalCzech": "zlom si nohu",
  "actualMeaningCzech": "hodně štěstí",
  "category": "idioms",
  "exampleEn": "Break a leg at your audition tonight!",
  "exampleCz": "Hodně štěstí na dnešním konkurzu!"
}
```
