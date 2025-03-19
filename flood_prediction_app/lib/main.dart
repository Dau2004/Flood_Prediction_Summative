import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/home_screen.dart';
import 'screens/input_screen.dart';
import 'screens/results_screen.dart';

void main() {
  // Web-specific setup for input issues
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    // This is a temporary workaround for web text input issues
    FlutterError.onError = (details) {
      if (!details.exception.toString().contains("The targeted input element must be the active input element")) {
        FlutterError.presentError(details);
      }
    };
  }
  
  runApp(const FloodPredictionApp());
}

class FloodPredictionApp extends StatelessWidget {
  const FloodPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flood Prediction',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/input': (context) => const InputScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}