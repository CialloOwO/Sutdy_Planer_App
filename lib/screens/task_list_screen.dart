import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/study_task.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart'; // Import the newly created form screen

class TaskListScreen extends StatefulWidget {
  // Use int? for highlightTaskId to match SQLite id type
  const TaskListScreen({super.key, this.highlightTaskId});
  final int? highlightTaskId;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Map<int, GlobalKey> _itemKeys = {};
  int? _highlightedTaskId;
  
  // Backend connection variables
  List<StudyTask> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshTasks(); // [READ] Fetch data from SQLite when screen loads
    _highlightedTaskId = widget.highlightTaskId;
  }

  /// [READ] Operation: Fetch all tasks from SQLite
  Future<void> _refreshTasks() async {
    setState(() => _isLoading = true);
    final data = await DBHelper.instance.getTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });

    // Handle scroll-to-highlight logic if a specific task was updated
    if (_highlightedTaskId != null && _tasks.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlightedTask());
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _highlightedTaskId == widget.highlightTaskId) {
          setState(() => _highlightedTaskId = null);
        }
      });
    }
  }

  void _scrollToHighlightedTask() {
    final taskId = widget.highlightTaskId;
    if (taskId == null) return;
    final key = _itemKeys[taskId];
    final context = key?.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.2,
    );
  }

  /// UI Widget for individual task card
  Widget taskCard(StudyTask task, {required bool isHighlighted}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted ? Border.all(color: const Color(0xFF3F51B5), width: 2) : null,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: const Color(0xFF3F51B5).withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isHighlighted ? const Color(0xFFE8EAF6) : null,
        child: ListTile(
          leading: Icon(
            isHighlighted ? Icons.push_pin : Icons.assignment,
            color: const Color(0xFF3F51B5),
          ),
          title: Text(
            task.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${task.course}\nDeadline: ${task.formattedDueDate}'),
          isThreeLine: true,
          trailing: Text(task.status, style: const TextStyle(fontWeight: FontWeight.w600)),
          onTap: () async {
            final changed = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
            );
            if (changed == true) {
              _refreshTasks();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Tasks')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : _tasks.isEmpty
              ? const Center(child: Text('No tasks found. Add one!')) // Empty state
              : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    'Swipe left on a task to delete it.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: _tasks.map((task) {
                      _itemKeys.putIfAbsent(task.id!, GlobalKey.new);
                      final isHighlighted = task.id == _highlightedTaskId;

                      return Padding(
                        key: _itemKeys[task.id],
                        padding: const EdgeInsets.only(bottom: 12),
                        // [DELETE] Operation integrated into UI using Swipe-to-Dismiss
                        child: Dismissible(
                          key: ValueKey(task.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white, size: 28),
                          ),
                          onDismissed: (direction) async {
                            final messenger = ScaffoldMessenger.of(context);
                            await DBHelper.instance.deleteTask(task.id!);
                            _refreshTasks();
                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Task deleted successfully')),
                            );
                          },
                          child: taskCard(task, isHighlighted: isHighlighted),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        onPressed: () async {
          // [CREATE] Navigate to Form Screen with null task (Add mode)
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
          _refreshTasks(); // Refresh list after returning from add screen
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}