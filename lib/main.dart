import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      // Screens show explicit retry buttons, so don't silently retry failed requests.
      retry: (_, _) => null,
      child: const FishDexApp(),
    ),
  );
}
