import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nav_provider.dart';
import 'convert_screen.dart';
import 'chart_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

// Bottom-nav shell that swaps between the 4 main tabs.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _screens = [
    ConvertScreen(),
    ChartScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();

    return Scaffold(
      body: IndexedStack(index: nav.index, children: _screens),
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
