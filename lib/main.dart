import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RateFlowApp());
}

class RateFlowApp extends StatelessWidget {
  const RateFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider()..load(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'RateFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.mode,
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}
