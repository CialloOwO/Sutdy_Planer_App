import 'package:flutter/material.dart';
import '../data/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            Text(
              UserSession.displayName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(UserSession.email.isEmpty ? 'Not logged in' : UserSession.email),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: Text(UserSession.programme),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(UserSession.year),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  UserSession.clear();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
