import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/substation_screen.dart';
import 'screens/systems_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/floating_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    SubstationScreen(),
    SystemsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TPColors.background,
      appBar: AppBar(
        backgroundColor: TPColors.surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
            ),
            child: IconButton(
              icon: const Icon(Icons.bolt, color: TPColors.primary),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          'TPCODL ACADEMY',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: TPColors.primary,
                letterSpacing: 3,
                fontSize: 15,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: const Icon(Icons.search, color: TPColors.primary),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Screen content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Floating nav bar
          FloatingNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ],
      ),
    );
  }
}
