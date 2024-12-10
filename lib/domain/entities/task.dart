import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String taskId;
  final int status;
  final String name;
  final int type;
  final String? description;
  final DateTime? finishDate;
  final int urgent;
  final String? file;

  const Task({
    required this.taskId,
    required this.status,
    required this.name,
    required this.type,
    this.description,
    this.finishDate,
    required this.urgent,
    this.file,
  });

  @override
  List<Object?> get props =>
      [taskId, status, name, type, description, finishDate, urgent, file];
}
