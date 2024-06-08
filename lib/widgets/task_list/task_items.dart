// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:task_tracker/models/task_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {Key? key, required this.onRemoveTask})
      : super(key: key);

  final TaskModal task;
  final void Function(TaskModal task) onRemoveTask;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isCompleted ? Colors.green[100] : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          children: [
            Checkbox(
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value!;
                });
                if (_isCompleted) {
                  showToast(
                    'Task Completed',
                    context: context,
                    animation: StyledToastAnimation.fade,
                    reverseAnimation: StyledToastAnimation.fade,
                    position: StyledToastPosition.bottom,
                    duration: const Duration(seconds: 2),
                    animDuration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    backgroundColor: const Color.fromARGB(255, 43, 165, 47),
                    textStyle: const TextStyle(color: Colors.white),
                  );
                }
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.task.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onRemoveTask(widget.task);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
