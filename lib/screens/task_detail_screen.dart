import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/study_task.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final StudyTask task;

  Color _statusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Widget _detailTile(IconData icon, String label, String value) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8EAF6),
          child: Icon(icon, color: const Color(0xFF3F51B5)),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('This task will be removed from the study list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted || task.id == null) return;

    await DBHelper.instance.deleteTask(task.id!);

    if (!context.mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(task.status);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF3F51B5),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      task.status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _detailTile(Icons.book, 'Course / Subject', task.course),
          _detailTile(Icons.calendar_today, 'Deadline', task.formattedDueDate),
          _detailTile(
            Icons.timelapse,
            'Days Remaining',
            task.daysUntilDue < 0
                ? 'Overdue'
                : '${task.daysUntilDue} day(s) remaining',
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withValues(alpha: 0.15),
                child: Icon(Icons.flag, color: statusColor),
              ),
              title: const Text(
                'Current Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(task.status),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(task: task),
                ),
              );
              if (context.mounted && updated == true) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Task'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _deleteTask(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete Task'),
          ),
        ],
      ),
    );
  }
}
