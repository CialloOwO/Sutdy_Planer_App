import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          SwitchListTile(
            value: true,
            onChanged: null,
            title: Text('Notifications'),
            secondary: Icon(Icons.notifications),
          ),
          SwitchListTile(
            value: false,
            onChanged: null,
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('English'),
          ),
          ListTile(leading: Icon(Icons.privacy_tip), title: Text('Privacy')),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About App'),
            subtitle: Text('Study Planner v1.0'),
          ),
        ],
      ),
    );
  }
}
