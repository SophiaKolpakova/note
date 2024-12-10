import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/task_item_widget.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = context.read<GetTasks>().call().then((result) {
      return result.fold((failure) => [], (tasks) => tasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Завдання'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Усі')),
              const PopupMenuItem(value: 'personal', child: Text('Особисті')),
              const PopupMenuItem(value: 'work', child: Text('Робочі')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Помилка завантаження завдань'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) =>
                  TaskItemWidget(task: tasks[index]),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
