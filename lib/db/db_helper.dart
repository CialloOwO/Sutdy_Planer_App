import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/study_task.dart';
import '../models/app_user.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('study_planner.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE study_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        course TEXT,
        dueDate TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        programme TEXT,
        year TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fullName TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          programme TEXT,
          year TEXT
        )
      ''');
    }
  }

  // ==========================================
  // STUDY TASK OPERATIONS
  // ==========================================

  Future<int> insertTask(StudyTask task) async {
    final db = await instance.database;
    return await db.insert('study_tasks', task.toMap());
  }

  Future<List<StudyTask>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('study_tasks', orderBy: 'dueDate ASC');
    return result.map((json) => StudyTask.fromMap(json)).toList();
  }

  Future<int> updateTask(StudyTask task) async {
    final db = await instance.database;
    return await db.update(
      'study_tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await instance.database;
    await db.delete(
      'study_tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // USER AUTH OPERATIONS
  // ==========================================

  Future<int> registerUser(AppUser user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<AppUser?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return AppUser.fromMap(result.first);
  }

  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  Future<AppUser?> loginUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user == null) return null;
    if (user.password != password) return null;
    return user;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
