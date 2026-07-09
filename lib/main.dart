import 'package:flutter/material.dart';
import 'screens/about_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/map_screen.dart';
import 'screens/media_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF3F51B5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          primary: const Color(0xFF3F51B5),
          secondary: const Color(0xFF5C6BC0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF3F51B5),
            side: const BorderSide(color: Color(0xFF3F51B5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 2),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: const Color(0xFFE8EAF6),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF3F51B5)
                  : Colors.black54,
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help': (context) => const HelpScreen(),
        '/about': (context) => const AboutScreen(),
        '/search': (context) => const SearchScreen(),
        '/map': (context) => const MapScreen(),
        '/media': (context) => const MediaScreen(),
        '/tasks': (context) {
          final highlightTaskId =
              ModalRoute.of(context)?.settings.arguments as int?;
          return TaskListScreen(highlightTaskId: highlightTaskId);
        },
      },
    );
  }
}
