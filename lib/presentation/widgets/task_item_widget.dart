import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/update_task.dart';
import 'package:provider/provider.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;

  const TaskItemWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description ?? ''),
      trailing: Checkbox(
        value: task.status == 2,
        onChanged: (value) {
          context.read<UpdateTask>().call(task.taskId, value! ? 2 : 1);
        },
      ),
      onTap: () {
        Navigator.pushNamed(context, '/edit', arguments: task);
      },
    );
  }
}
