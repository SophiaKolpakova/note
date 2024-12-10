import 'package:dartz/dartz.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, void>> call(String taskId) async {
    return await repository.deleteTask(taskId);
  }
}
