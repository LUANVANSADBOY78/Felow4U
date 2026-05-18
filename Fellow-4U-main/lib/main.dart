import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'core/app_localizations.dart';

void main() {
  runApp(const Fellow4UApp());
}

class Fellow4UApp extends StatefulWidget {
  const Fellow4UApp({super.key});

  @override
  State<Fellow4UApp> createState() => _Fellow4UAppState();
}

class _Fellow4UAppState extends State<Fellow4UApp> {
  @override
  void initState() {
    super.initState();
    // Rebuild the whole app whenever language changes
    languageNotifier.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fellow4U',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C897),
          primary: const Color(0xFF00C897),
        ),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
