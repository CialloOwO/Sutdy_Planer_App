import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE8EAF6),
              child: Icon(icon, color: const Color(0xFF3F51B5)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(body, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Study Planner')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.school, size: 72, color: Color(0xFF3F51B5)),
          const SizedBox(height: 12),
          const Text(
            'Study Planner',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Version 1.0',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            icon: Icons.flag,
            title: 'Purpose',
            body:
                'This app helps students organise study tasks, track deadlines, and review progress from one dashboard.',
          ),
          _sectionCard(
            icon: Icons.widgets,
            title: 'Front-end Contribution',
            body:
                'Screen layout, navigation flow, UI consistency, search interface, task detail page, map page layout, multimedia page layout, screenshots, and recording flow.',
          ),
          _sectionCard(
            icon: Icons.storage,
            title: 'Back-end Member Area',
            body:
                'SQLite database, user authentication, task CRUD logic, data models, map plugin integration, and multimedia playback logic.',
          ),
          _sectionCard(
            icon: Icons.code,
            title: 'Technologies',
            body:
                'Flutter, Dart, SQLite, OpenStreetMap integration, and audio or video playback plugin.',
          ),
        ],
      ),
    );
  }
}
