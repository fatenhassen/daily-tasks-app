import 'package:daily_tasks_app/core/app_colors.dart';
import 'package:daily_tasks_app/features/presentation/cubit/add_task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/task_item_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        final cubit = context.read<AddTaskCubit>();
        final allTasks = state is AddTaskLoaded ? state.tasks : [];
        final pendingTasks = allTasks
            .where((task) => !task.isCompleted)
            .toList();
        final completedTasks = allTasks
            .where((task) => task.isCompleted)
            .toList();
        final totalTasks = allTasks.length;
        final completedCount = completedTasks.length;
        final progress = totalTasks > 0 ? completedCount / totalTasks : 0.0;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Stack(
            children: [
              // Gradient background
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.buttonGradient,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "My Daily Tasks",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Progress card
                        _buildProgressCard(
                          progress,
                          completedCount,
                          totalTasks,
                        ),
                        const SizedBox(height: 30),
                        // Pending tasks section
                        if (pendingTasks.isEmpty && completedTasks.isEmpty)
                          _buildEmptyState()
                        else if (pendingTasks.isNotEmpty) ...[
                          const Text(
                            "Priorities",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pendingTasks.length,
                            itemBuilder: (context, index) => TaskItemWidget(
                              task: pendingTasks[index],
                              onToggleComplete: (isCompleted) {
                                final updatedTask = pendingTasks[index]
                                    .copyWith(isCompleted: isCompleted);
                                cubit.updateTask(
                                  pendingTasks[index],
                                  updatedTask,
                                );
                              },
                              onDelete: () {
                                cubit.deleteTask(pendingTasks[index]);
                              },
                            ),
                          ),
                        ],
                        // Completed tasks section
                        if (completedTasks.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            "Completed (${completedTasks.length})",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: completedTasks.length,
                            itemBuilder: (context, index) => TaskItemWidget(
                              task: completedTasks[index],
                              onToggleComplete: (isCompleted) {
                                final updatedTask = completedTasks[index]
                                    .copyWith(isCompleted: isCompleted);
                                cubit.updateTask(
                                  completedTasks[index],
                                  updatedTask,
                                );
                              },
                              onDelete: () {
                                cubit.deleteTask(completedTasks[index]);
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 20), // Add bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add-task'),
            backgroundColor: AppColors.primaryTeal,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(
    double progress,
    int completedCount,
    int totalTasks,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Progress",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryTeal,
            ),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$completedCount/$totalTasks Tasks",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                totalTasks > 0 ? "${(progress * 100).toInt()}%" : "0%",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.task_alt_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No tasks yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding some tasks to get organized!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
