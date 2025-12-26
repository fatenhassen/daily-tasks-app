import 'package:flutter/material.dart';
import 'package:daily_tasks_app/features/data/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [
    TaskModel(
      title: 'Team Meeting',
      category: 'Work',
      time: '10:00 AM',
      categoryColor: Colors.blue,
    ),
    TaskModel(
      title: 'Gym Session',
      category: 'Health',
      time: '07:00 AM',
      categoryColor: Colors.green,
    ),
    TaskModel(
      title: 'Grocery Shopping',
      category: 'Personal',
      time: '05:00 PM',
      categoryColor: Colors.orange,
    ),
  ];

  List<TaskModel> get tasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  void addTask(TaskModel task) {
    _tasks = [..._tasks, task];
    notifyListeners();
  }

  void toggleTaskCompletion(TaskModel task) {
    final index = _tasks.indexWhere((t) => t.title == task.title);
    if (index != -1) {
      _tasks = [
        ..._tasks.sublist(0, index),
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted),
        ..._tasks.sublist(index + 1),
      ];
      notifyListeners();
    }
  }

  void deleteTask(TaskModel task) {
    _tasks = _tasks.where((t) => t.title != task.title).toList();
    notifyListeners();
  }

  // For debugging
  void printTasks() {
    debugPrint('Current tasks:');
    for (var task in _tasks) {
      debugPrint('${task.title} - Completed: ${task.isCompleted}');
    }
  }
}
