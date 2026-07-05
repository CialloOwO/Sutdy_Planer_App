import 'package:flutter/material.dart';
import '../data/user_session.dart';
import '../db/db_helper.dart'; // Import local database
import '../models/study_task.dart';
import 'task_form_screen.dart'; // Import to enable direct Add Task routing

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudyTask> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData(); // Load dynamic data on init
  }

  /// Fetch tasks from SQLite to calculate dashboard statistics
  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final data = await DBHelper.instance.getTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  Widget menuCard(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3F51B5)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          // Await the route, so if tasks are modified there, we refresh stats upon return
          await Navigator.pushNamed(context, route);
          _loadDashboardData();
        },
      ),
    );
  }

  Widget statItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget upcomingTaskCard(BuildContext context, StudyTask task) {
    final daysLeft = task.daysUntilDue;
    final dueLabel = daysLeft == 0
        ? 'Due today'
        : daysLeft == 1
        ? 'Due tomorrow'
        : daysLeft < 0
        ? 'Overdue'
        : 'Due ${task.shortDueDate}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF3F51B5).withValues(alpha: 0.12),
          child: const Icon(Icons.event, color: Color(0xFF3F51B5)),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${task.course}\n$dueLabel'),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(task.status).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.status,
            style: TextStyle(
              color: _statusColor(task.status),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () async {
          // Navigate to edit form directly from home screen
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
          );
          _loadDashboardData();
        },
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Dynamic Database Statistics Calculations
    final totalTaskCount = _tasks.length;
    final pendingCount = _tasks.where((t) => t.status == 'Pending').length;
    final inProgressCount = _tasks
        .where((t) => t.status == 'In Progress')
        .length;
    final dueThisWeekCount = _tasks
        .where((t) => t.daysUntilDue >= 0 && t.daysUntilDue <= 7)
        .length;

    // Get up to 3 upcoming tasks dynamically
    final upcomingList = _tasks.where((t) => t.daysUntilDue >= 0).toList()
      ..sort((a, b) => a.daysUntilDue.compareTo(b.daysUntilDue));
    final upcomingTasks = upcomingList.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Study Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              '${UserSession.timeBasedGreeting}, ${UserSession.firstName}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              UserSession.formattedToday,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            const Text('Manage your study tasks and deadlines easily.'),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF3F51B5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today’s Study Plan',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        statItem('Total', '$totalTaskCount'),
                        const SizedBox(width: 8),
                        statItem('Pending', '$pendingCount'),
                        const SizedBox(width: 8),
                        statItem('In Progress', '$inProgressCount'),
                        const SizedBox(width: 8),
                        statItem('Due (7d)', '$dueThisWeekCount'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Connect "Add Task" button directly to the form
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskFormScreen(),
                        ),
                      );
                      _loadDashboardData(); // Refresh stats when returning
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/tasks');
                      _loadDashboardData(); // Refresh stats when returning
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text('View All'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF3F51B5),
                      side: const BorderSide(color: Color(0xFF3F51B5)),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Deadlines (7 days)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (upcomingTasks.isEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text('No upcoming deadlines'),
                  subtitle: Text('No tasks due within the next 7 days.'),
                ),
              )
            else
              ...upcomingTasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: upcomingTaskCard(context, task),
                ),
              ),
            const SizedBox(height: 12),
            menuCard(context, Icons.task, 'My Tasks', '/tasks'),
            menuCard(context, Icons.person, 'Profile', '/profile'),
            menuCard(context, Icons.settings, 'Settings', '/settings'),
            menuCard(context, Icons.help, 'Help & Support', '/help'),
          ],
        ),
      ),
    );
  }
}
