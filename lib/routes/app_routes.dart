import 'package:daily_tasks_app/features/presentation/screens/add_task_screen.dart';
import 'package:daily_tasks_app/features/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
 

class AppRoutes {
  static const String home = '/';
  static const String addTask = '/add-task';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}