import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/converter_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/nav_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_shell.dart';
import 'services/rate_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RateFlowApp());
}

class RateFlowApp extends StatelessWidget {
  // Lets tests swap in a fake RateService instead of making real network
  // calls, so widget/screenshot tests don't depend on the internet.
  final RateService? rateService;

  const RateFlowApp({super.key, this.rateService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        ChangeNotifierProvider(
          create: (_) => ConverterProvider(rateService: rateService)..convert(),
        ),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..load()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'RateFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.mode,
            home: HomeShell(rateService: rateService),
          );
        },
      ),
    );
  }
}
