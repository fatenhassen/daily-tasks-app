import 'package:flutter/material.dart';

class TaskModel {
  final String title;
  final String category;
  final String time;
  final Color categoryColor;
  final bool isCompleted;

  TaskModel({
    required this.title,
    required this.category,
    required this.time,
    required this.categoryColor,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? title,
    String? category,
    String? time,
    Color? categoryColor,
    bool? isCompleted,
  }) {
    return TaskModel(
      title: title ?? this.title,
      category: category ?? this.category,
      time: time ?? this.time,
      categoryColor: categoryColor ?? this.categoryColor,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
