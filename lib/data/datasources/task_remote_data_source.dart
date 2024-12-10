import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../../core/error/exceptions.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();

  Future<void> createTask(TaskModel task);

  Future<void> updateTask(String taskId, int status);

  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://to-do.softwars.com.ua/{kolpakova2004@gmail.com}/';

  TaskRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await client.get(Uri.parse('${baseUrl}tasks'));
    if (response.statusCode == 200) {
      final List tasksJson = json.decode(response.body)['data'];
      return tasksJson.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    final response = await client.post(
      Uri.parse('${baseUrl}tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode != 200) throw ServerException();
  }

  @override
  Future<void> updateTask(String taskId, int status) async {
    final response = await client.put(
      Uri.parse('${baseUrl}tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
    if (response.statusCode != 200) throw ServerException();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final response = await client.delete(Uri.parse('${baseUrl}tasks/$taskId'));
    if (response.statusCode != 200) throw ServerException();
  }
}
