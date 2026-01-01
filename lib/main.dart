import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/artifact_provider.dart';
import 'presentation/screens/map_screen.dart';

Future<void> main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize locale data for date formatting
  await initializeDateFormatting('ru', null);
  runApp(const ArchaeologyApp());
}

class ArchaeologyApp extends StatelessWidget {
  const ArchaeologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArtifactProvider(),
      child: MaterialApp(
        title: 'Archaeology Treasures',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const MapScreen(),
      ),
    );
  }
}
