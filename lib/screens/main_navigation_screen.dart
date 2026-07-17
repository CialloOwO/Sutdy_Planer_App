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
  
  // [新增] 为三个需要刷新的页面分配独立的触发器
  int _homeRefreshTrigger = 0;
  int _taskRefreshTrigger = 0; 
  int _searchRefreshTrigger = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      
      // 根据点击的 Tab，精确增加对应的触发器
      if (index == 0) {
        _homeRefreshTrigger++;
      } else if (index == 1) {
        _taskRefreshTrigger++;
      } else if (index == 2) {
        _searchRefreshTrigger++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      // [修改] 将三个触发器全部对接完毕
      HomeScreen(refreshTrigger: _homeRefreshTrigger),
      TaskListScreen(refreshTrigger: _taskRefreshTrigger),
      SearchScreen(refreshTrigger: _searchRefreshTrigger),
      const MapScreen(),
      const MediaScreen(),
    ];

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
      body: IndexedStack(index: _selectedIndex, children: screens),
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