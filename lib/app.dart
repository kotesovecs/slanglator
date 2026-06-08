import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Global theme mode, toggled from the UI.
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.system);

/// Hidden "literal mode" easter egg. When enabled, previews show the literal
/// translation and the detail screen swaps the literal and actual meanings.
/// Toggled by tapping the header logo 6 times in a row.
final ValueNotifier<bool> literalModeNotifier = ValueNotifier<bool>(false);

class SlanglatorApp extends StatelessWidget {
  const SlanglatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Slanglator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
