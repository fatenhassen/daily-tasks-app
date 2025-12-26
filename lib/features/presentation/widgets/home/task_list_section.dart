import 'package:daily_tasks_app/features/data/models/task_model.dart';
import 'package:daily_tasks_app/features/presentation/cubit/add_task_cubit.dart';
import 'package:daily_tasks_app/features/presentation/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListSection extends StatelessWidget {
  final String title;
  final List<TaskModel> tasks;
  final bool isCompletedSection;

  const TaskListSection({
    super.key,
    required this.title,
    required this.tasks,
    this.isCompletedSection = false,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final cubit = context.read<AddTaskCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isCompletedSection) const SizedBox(height: 20),
        Text(
          isCompletedSection ? "$title (${tasks.length})" : title,
          style: TextStyle(
            fontSize: isCompletedSection ? 16 : 20,
            color: isCompletedSection ? Colors.grey : Colors.black,
            fontWeight: isCompletedSection ? FontWeight.w500 : FontWeight.bold,
          ),
        ),
        if (!isCompletedSection) const SizedBox(height: 15),
        if (isCompletedSection) const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) => TaskItemWidget(
            task: tasks[index],
            onToggleComplete: (isCompleted) {
              final updatedTask = tasks[index].copyWith(
                isCompleted: isCompleted,
              );
              cubit.updateTask(tasks[index], updatedTask);
            },
            onDelete: () {
              cubit.deleteTask(tasks[index]);
            },
          ),
        ),
      ],
    );
  }
}
