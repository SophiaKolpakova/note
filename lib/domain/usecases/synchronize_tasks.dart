import 'package:dartz/dartz.dart';
import '../repositories/task_repository.dart';
import '../../core/error/failures.dart';

class SynchronizeTasks {
  final TaskRepository repository;

  SynchronizeTasks(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.synchronizeTasks();
  }
}
