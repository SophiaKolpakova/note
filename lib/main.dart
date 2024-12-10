import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';
import 'data/datasources/task_remote_data_source.dart';
import 'data/datasources/task_local_data_source.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/create_task.dart';
import 'domain/usecases/update_task.dart';
import 'domain/usecases/delete_task.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/task_form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NetworkInfoImpl(Connectivity())),
        Provider(
            create: (context) =>
                TaskRemoteDataSourceImpl(client: http.Client())),
        Provider(create: (context) => TaskLocalDataSourceImpl()),
        Provider(
          create: (context) => TaskRepositoryImpl(
            remoteDataSource: context.read<TaskRemoteDataSource>(),
            localDataSource: context.read<TaskLocalDataSource>(),
            networkInfo: context.read<NetworkInfo>(),
          ),
        ),
        Provider(create: (context) => GetTasks(context.read<TaskRepository>())),
        Provider(
            create: (context) => CreateTask(context.read<TaskRepository>())),
        Provider(
            create: (context) => UpdateTask(context.read<TaskRepository>())),
        Provider(
            create: (context) => DeleteTask(context.read<TaskRepository>())),
      ],
      child: MaterialApp(
        title: 'To-Do App',
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/create': (context) => TaskFormScreen(),
        },
      ),
    );
  }
}
