import 'package:dartz/dartz.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, void>> call(String taskId, int status) async {
    return await repository.updateTask(taskId, status);
  }
}
