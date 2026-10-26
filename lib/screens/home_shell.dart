import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nav_provider.dart';
import '../services/rate_service.dart';
import 'convert_screen.dart';
import 'chart_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

// Bottom-nav shell that swaps between the 4 main tabs.
class HomeShell extends StatelessWidget {
  final RateService? rateService;

  const HomeShell({super.key, this.rateService});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();

    final screens = [
      const ConvertScreen(),
      ChartScreen(rateService: rateService),
      FavoritesScreen(rateService: rateService),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: nav.index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.index,
        onDestinationSelected: nav.goTo,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Convert'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Chart'),
          NavigationDestination(icon: Icon(Icons.star_border), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
