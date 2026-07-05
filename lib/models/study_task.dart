class StudyTask {
  int? id;
  String title;
  String course; // Changed from description to match UI
  String dueDate; // Format: "yyyy-MM-dd"
  String status; // E.g., 'Pending', 'In Progress', 'Completed'

  StudyTask({
    this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.status = 'Pending', // Default status
  });

  /// Convert object to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'dueDate': dueDate,
      'status': status,
    };
  }

  /// Convert Map from SQLite to Object
  factory StudyTask.fromMap(Map<String, dynamic> map) {
    return StudyTask(
      id: map['id'],
      title: map['title'],
      course: map['course'],
      dueDate: map['dueDate'],
      status: map['status'],
    );
  }

  // ==========================================
  // HELPER GETTERS FOR UI (Matched to Teammate's Code)
  // ==========================================
  
  DateTime get parsedDate => DateTime.parse(dueDate);
  
  String get formattedDueDate => "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
  
  String get shortDueDate => "${parsedDate.month}/${parsedDate.day}";
  
  int get daysUntilDue => parsedDate.difference(DateTime.now()).inDays;
}