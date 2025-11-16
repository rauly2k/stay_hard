import 'package:flutter/material.dart';
import '../../../features/alarms/presentation/pages/alarms_screen.dart';
import '../../../features/analytics/presentation/pages/analytics_screen.dart';
import '../../../features/focus/presentation/pages/focus_screen.dart';
import '../../../features/goals/presentation/pages/goals_screen.dart';
import '../../../features/home/presentation/pages/home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    GoalsScreen(),
    AlarmsScreen(),
    FocusScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primaryContainer,
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm),
            selectedIcon: Icon(Icons.alarm),
            label: 'Alarms',
          ),
          NavigationDestination(
            icon: Icon(Icons.center_focus_strong_outlined),
            selectedIcon: Icon(Icons.center_focus_strong),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
