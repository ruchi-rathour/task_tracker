import 'package:flutter/material.dart';
import 'package:task_tracker/models/task_model.dart';
import 'package:task_tracker/widgets/task_list/task_items.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.tasks,
    required this.onRemoveTask,
  }) : super(key: key);

  final List<TaskModal> tasks;
  final void Function(TaskModal task) onRemoveTask;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(tasks[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) {
          onRemoveTask(tasks[index]);
        },
        child: TaskItem(
          tasks[index],
          onRemoveTask: (TaskModal task) {
            onRemoveTask(tasks[index]);
          },
        ),
      ),
    );
  }
}
