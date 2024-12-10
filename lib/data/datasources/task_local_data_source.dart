import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasks);

  Future<List<TaskModel>> getCachedTasks();

  Future<void> insertTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<void> updateTaskStatus(String taskId, int status);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(taskId TEXT PRIMARY KEY, status INTEGER, name TEXT, type INTEGER, description TEXT, finishDate TEXT, urgent INTEGER, file TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('tasks');
      for (var task in tasks) {
        await txn.insert('tasks', task.toJson());
      }
    });
  }

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return List.generate(maps.length, (i) => TaskModel.fromJson(maps[i]));
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert('tasks', task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete('tasks', where: 'taskId = ?', whereArgs: [taskId]);
  }

  @override
  Future<void> updateTaskStatus(String taskId, int status) async {
    final db = await database;
    await db.update('tasks', {'status': status},
        where: 'taskId = ?', whereArgs: [taskId]);
  }
}
