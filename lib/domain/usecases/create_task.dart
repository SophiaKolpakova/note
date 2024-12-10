import 'package:dartz/dartz.dart' hide Task;
import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Either<Failure, void>> call(Task task) async {
    return await repository.createTask(task);
  }
}
