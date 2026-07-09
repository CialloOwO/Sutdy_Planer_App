import 'package:flutter/material.dart';

import '../data/user_session.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'media_screen.dart';
import 'search_screen.dart';
import 'task_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TaskListScreen(),
    SearchScreen(),
    MapScreen(),
    MediaScreen(),
  ];

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF3F51B5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.school, color: Colors.white, size: 48),
                    const Spacer(),
                    Text(
                      UserSession.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      UserSession.email.isEmpty
                          ? 'Study Planner'
                          : UserSession.email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & FAQ'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/help');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  UserSession.clear();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.task), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Media'),
        ],
      ),
    );
  }
}
