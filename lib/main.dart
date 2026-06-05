import 'package:flutter/material.dart';

import 'app.dart';
import 'services/favorites_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesService.instance.load();
  runApp(const SlanglatorApp());
}
