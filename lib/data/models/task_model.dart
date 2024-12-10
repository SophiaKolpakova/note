import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String taskId,
    required int status,
    required String name,
    required int type,
    String? description,
    DateTime? finishDate,
    required int urgent,
    String? file,
  }) : super(
          taskId: taskId,
          status: status,
          name: name,
          type: type,
          description: description,
          finishDate: finishDate,
          urgent: urgent,
          file: file,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'],
      status: json['status'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      finishDate: json['finishDate'] != null
          ? DateTime.parse(json['finishDate'])
          : null,
      urgent: json['urgent'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'status': status,
      'name': name,
      'type': type,
      'description': description,
      'finishDate': finishDate?.toIso8601String(),
      'urgent': urgent,
      'file': file,
    };
  }
}
