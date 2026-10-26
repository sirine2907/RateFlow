import 'package:flutter/material.dart';
import 'convert_screen.dart';
import 'chart_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

// Bottom-nav shell that swaps between the 4 main tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    ConvertScreen(),
    ChartScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
