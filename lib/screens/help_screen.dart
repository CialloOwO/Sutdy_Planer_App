import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              title: Text('How to add a study task?'),
              subtitle: Text('Go to My Tasks and tap the add button.'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('How to edit a task?'),
              subtitle: Text(
                'Select a task from the list and update its details.',
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('How to delete a task?'),
              subtitle: Text('Tap the delete icon on the task card.'),
            ),
          ),
          SizedBox(height: 16),
          Text('Contact: support@studyplanner.com'),
        ],
      ),
    );
  }
}
