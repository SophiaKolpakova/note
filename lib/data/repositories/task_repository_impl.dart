import 'package:dartz/dartz.dart' as dartz;
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<Failure, List<Task>>> getTasks() async {
    if (await networkInfo.isConnected) {
      try {
        final tasks = await remoteDataSource.getTasks();
        await localDataSource.cacheTasks(tasks);
        return dartz.Right(tasks);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      try {
        final tasks = await localDataSource.getCachedTasks();
        return dartz.Right(tasks);
      } on CacheException {
        return dartz.Left(CacheFailure());
      }
    }
  }

  @override
  Future<dartz.Either<Failure, void>> createTask(Task task) async {
    final taskModel = TaskModel(
      taskId: task.taskId,
      status: task.status,
      name: task.name,
      type: task.type,
      description: task.description,
      finishDate: task.finishDate,
      urgent: task.urgent,
      file: task.file,
    );

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createTask(taskModel);
        await localDataSource.insertTask(taskModel);
        return const dartz.Right(null);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      await localDataSource.insertTask(taskModel);
      return const dartz.Right(null);
    }
  }

  @override
  Future<dartz.Either<Failure, void>> updateTask(
      String taskId, int status) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateTask(taskId, status);
        await localDataSource.updateTaskStatus(taskId, status);
        return const dartz.Right(null);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      await localDataSource.updateTaskStatus(taskId, status);
      return const dartz.Right(null);
    }
  }

  @override
  Future<dartz.Either<Failure, void>> deleteTask(String taskId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTask(taskId);
        await localDataSource.deleteTask(taskId);
        return const dartz.Right(null);
      } on ServerException {
        return dartz.Left(ServerFailure());
      }
    } else {
      await localDataSource.deleteTask(taskId);
      return const dartz.Right(null);
    }
  }

  @override
  Future<dartz.Either<Failure, void>> synchronizeTasks() async {
    return const dartz.Right(null);
  }
}
