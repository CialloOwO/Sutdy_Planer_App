import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/study_task.dart';
import 'task_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  // [新增] 增加 refreshTrigger 参数
  const SearchScreen({super.key, this.refreshTrigger = 0});
  final int refreshTrigger;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<StudyTask> _tasks = [];
  String _statusFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // [新增核心修复逻辑] 监听外部传入的 refreshTrigger 变化
  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果底部导航栏被点击，触发器数字发生变化，立刻刷新数据库数据！
    if (widget.refreshTrigger != oldWidget.refreshTrigger) {
      _loadTasks();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final data = await DBHelper.instance.getTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  List<StudyTask> get _filteredTasks {
    final keyword = _searchController.text.trim().toLowerCase();

    return _tasks.where((task) {
      final matchesKeyword =
          keyword.isEmpty ||
          task.title.toLowerCase().contains(keyword) ||
          task.course.toLowerCase().contains(keyword);
      final matchesStatus =
          _statusFilter == 'All' || task.status == _statusFilter;
      return matchesKeyword && matchesStatus;
    }).toList();
  }

  Widget _statusChip(String label) {
    final selected = _statusFilter == label;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _statusFilter = label),
      selectedColor: const Color(0xFFE8EAF6),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF3F51B5) : Colors.black87,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Search Tasks')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTasks,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Search by title or course',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusChip('All'),
                      _statusChip('Pending'),
                      _statusChip('In Progress'),
                      _statusChip('Completed'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${filteredTasks.length} result(s)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (filteredTasks.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              color: Color(0xFF3F51B5),
                              size: 42,
                            ),
                            SizedBox(height: 10),
                            Text('No matching tasks found.'),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filteredTasks.map(
                      (task) => Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.assignment,
                            color: Color(0xFF3F51B5),
                          ),
                          title: Text(
                            task.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${task.course}\nDeadline: ${task.formattedDueDate}',
                          ),
                          isThreeLine: true,
                          trailing: Text(task.status),
                          onTap: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailScreen(task: task),
                              ),
                            );
                            if (changed == true) {
                              _loadTasks();
                            }
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Back-end member can optionally replace this local filtering with a DBHelper.searchTasks() query.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}