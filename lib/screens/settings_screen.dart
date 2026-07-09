import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SwitchListTile(
            value: true,
            onChanged: null,
            title: Text('Notifications'),
            secondary: Icon(Icons.notifications),
          ),
          const SwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('English'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy'),
            subtitle: const Text('Local SQLite data stays on this device.'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            subtitle: const Text('Study Planner v1.0'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
    );
  }
}
