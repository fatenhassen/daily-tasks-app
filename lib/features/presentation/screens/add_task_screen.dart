import 'package:daily_tasks_app/core/app_colors.dart';
import 'package:daily_tasks_app/features/data/models/task_model.dart';
import 'package:daily_tasks_app/features/domain/models/category_model.dart';
import 'package:daily_tasks_app/features/presentation/cubit/add_task_cubit.dart';
import 'package:daily_tasks_app/features/presentation/widgets/add_task/category_selection.dart';
import 'package:daily_tasks_app/features/presentation/widgets/add_task/save_task_button.dart';
import 'package:daily_tasks_app/features/presentation/widgets/add_task/task_details_section.dart';
import 'package:daily_tasks_app/features/presentation/widgets/add_task/task_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late DateTime _selectedDate;
  String _selectedPriority = 'Medium';
  String _selectedCategory = 'PERSONAL';

  final List<Category> _categories = [
    Category(
      id: 'PERSONAL',
      name: 'Personal',
      icon: Icons.person_outline,
      color: AppColors.primaryTeal,
    ),
    Category(
      id: 'WORK',
      name: 'Work',
      icon: Icons.work_outline,
      color: AppColors.primaryTeal,
    ),
    Category(
      id: 'SHOPPING',
      name: 'Shopping',
      icon: Icons.shopping_cart_outlined,
      color: AppColors.secondaryYellow,
    ),
    Category(
      id: 'HEALTH',
      name: 'Health',
      icon: Icons.health_and_safety_outlined,
      color: Colors.red,
    ),
    Category(
      id: 'STUDY',
      name: 'Study',
      icon: Icons.school_outlined,
      color: Colors.blue,
    ),
    Category(
      id: 'FITNESS',
      name: 'Fitness',
      icon: Icons.fitness_center_outlined,
      color: Colors.green,
    ),
    Category(
      id: 'FINANCE',
      name: 'Finance',
      icon: Icons.attach_money_outlined,
      color: Colors.orange,
    ),
  ];

  Category get _selectedCategoryData => _categories.firstWhere(
    (category) => category.id == _selectedCategory,
    orElse: () => _categories.first,
  );

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Format the time to ensure consistent format (e.g., 09:05 instead of 9:5)
      final formattedTime =
          '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}';

      // Create a new task with the form data
      final task = TaskModel(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        time: formattedTime,
        categoryColor: _selectedCategoryData.color,
        isCompleted: false,
      );

      // Add the task using the cubit
      context.read<AddTaskCubit>().addTask(task);

      // Navigation is handled by the BlocListener
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          // Navigate back to home screen when task is added successfully
          Navigator.pop(context);
        } else if (state is AddTaskError) {
          // Show error message if task addition fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildForm(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
      title: const Text(
        "New Task",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Title Field
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: TaskInputField(
              controller: _titleController,
              hintText: 'What needs to be done?',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24.0),

          // Divider
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 24.0),

          // Category Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CategorySelection(
              selectedCategoryId: _selectedCategory,
              categories: _categories,
              onCategorySelected: (categoryId) {
                setState(() {
                  _selectedCategory = categoryId;
                });
              },
            ),
          ),

          const SizedBox(height: 32.0),

          // Task Details Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TaskDetailsSection(
              selectedDate: _selectedDate,
              selectedPriority: _selectedPriority,
              priorities: _priorities,
              onDatePressed: () => _selectDate(context),
              onPrioritySelected: (priority) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
            ),
          ),

          const Spacer(),

          // Bottom safe area padding
          const SizedBox(height: 24.0),

          // Save Button
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
            child: SaveTaskButton(onPressed: _submitForm, label: 'Save Task'),
          ),
        ],
      ),
    );
  }
}
