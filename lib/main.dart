import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/map_screen.dart';
import 'presentation/providers/artifact_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArchaeologyApp());
}

class ArchaeologyApp extends StatelessWidget {
  const ArchaeologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ArtifactProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Archaeology Map',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: MapScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0E0E0E),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
