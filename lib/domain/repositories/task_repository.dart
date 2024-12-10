import 'package:dartz/dartz.dart' as dartz;
import '../entities/task.dart';
import '../../core/error/failures.dart';

abstract class TaskRepository {
  Future<dartz.Either<Failure, List<Task>>> getTasks();

  Future<dartz.Either<Failure, void>> createTask(Task task);

  Future<dartz.Either<Failure, void>> updateTask(String taskId, int status);

  Future<dartz.Either<Failure, void>> deleteTask(String taskId);

  Future<dartz.Either<Failure, void>> synchronizeTasks();
}
