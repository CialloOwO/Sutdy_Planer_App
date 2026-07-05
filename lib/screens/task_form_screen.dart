import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/study_task.dart';

class TaskFormScreen extends StatefulWidget {
  // If task is null, it's "Create" mode. If provided, it's "Update" mode.
  final StudyTask? task; 

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late TextEditingController _titleController;
  late TextEditingController _courseController;
  late TextEditingController _dueDateController;
  String _status = 'Pending';

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if editing
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _courseController = TextEditingController(text: widget.task?.course ?? '');
    _dueDateController = TextEditingController(text: widget.task?.dueDate ?? '');
    _status = widget.task?.status ?? 'Pending';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  /// Show DatePicker for due date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.task != null ? DateTime.parse(widget.task!.dueDate) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  /// Execute CRUD logic (Create or Update)
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final newTask = StudyTask(
        id: widget.task?.id,
        title: _titleController.text,
        course: _courseController.text,
        dueDate: _dueDateController.text,
        status: _status,
      );

      if (widget.task == null) {
        // [CREATE] Insert new task to SQLite
        await DBHelper.instance.insertTask(newTask);
      } else {
        // [UPDATE] Update existing task in SQLite
        await DBHelper.instance.updateTask(newTask);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return success to previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Study Task' : 'Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(24), // Matches teammate's padding
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(), // Matches teammate's border style
                  prefixIcon: Icon(Icons.title), // Matches teammate's icon usage
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16), // Matches teammate's spacing
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course / Subject',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a course' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDateController,
                readOnly: true, 
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                items: ['Pending', 'In Progress', 'Completed'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24), // Matches teammate's spacing before button
              SizedBox(
                height: 48, // Matches teammate's button height
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5), // Using the theme color from home_screen
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'Update Task' : 'Create Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}