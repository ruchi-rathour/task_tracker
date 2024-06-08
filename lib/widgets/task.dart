// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker/models/task_model.dart';
import 'package:task_tracker/widgets/new_task.dart';
import 'package:task_tracker/widgets/task_list/task_list.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late SharedPreferences _prefs;
  final List<TaskModal> _registeredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    final tasksJson = _prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> tasksData =
          json.decode(tasksJson); // Use json.decode here
      setState(() {
        _registeredTasks
            .addAll(tasksData.map((data) => TaskModal.fromJson(data)));
      });
    }
  }

  Future<void> _saveTasks() async {
    final tasksJson = TaskModal.encodeJsonList(_registeredTasks);
    await _prefs.setString('tasks', tasksJson);
  }

  void _openAddTaskOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  void _addTask(TaskModal task) {
    setState(() {
      _registeredTasks.add(task);
    });
    showToast(
      'Task Added',
      context: context,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 2),
      animDuration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      backgroundColor: Colors.lightBlue,
      textStyle: const TextStyle(color: Colors.white),
    );
    _saveTasks();
  }

  void _removeTask(TaskModal task) {
    setState(() {
      _registeredTasks.remove(task);
    });
    showToast(
      'Task Removed',
      context: context,
      animation: StyledToastAnimation.fade,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 2),
      animDuration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      backgroundColor: Colors.red,
      textStyle: const TextStyle(color: Colors.white),
      onDismiss: () {
        _showUndoOption(task);
      },
    );
    _saveTasks();
  }

  void _showUndoOption(TaskModal removedTask) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task Removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredTasks.add(removedTask);
            });
            _saveTasks(); // Save the updated tasks
            showToast(
              'Task Restored',
              context: context,
              animation: StyledToastAnimation.fade,
              reverseAnimation: StyledToastAnimation.fade,
              position: StyledToastPosition.bottom,
              duration: const Duration(seconds: 2),
              animDuration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              backgroundColor: Colors.green,
              textStyle: const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter TaskTracker'),
        actions: [
          IconButton(
            onPressed: _openAddTaskOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _registeredTasks.isNotEmpty
          ? TaskList(
              tasks: _registeredTasks,
              onRemoveTask: _removeTask,
            )
          : const Center(
              child: Text(
                'No tasks yet. Add a task to get started!',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
