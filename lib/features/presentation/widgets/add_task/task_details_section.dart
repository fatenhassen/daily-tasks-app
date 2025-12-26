 
import 'package:daily_tasks_app/features/presentation/widgets/add_task/detail_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailsSection extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedPriority;
  final List<String> priorities;
  final VoidCallback onDatePressed;
  final Function(String) onPrioritySelected;

  const TaskDetailsSection({
    super.key,
    required this.selectedDate,
    required this.selectedPriority,
    required this.priorities,
    required this.onDatePressed,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        DetailTile(
          icon: Icons.calendar_today_outlined,
          title: 'Due Date',
          value: DateFormat('EEE, MMM d, y').format(selectedDate),
          onTap: onDatePressed,
          showChevron: true,
        ),
        const SizedBox(height: 8),
        DetailTile(
          icon: Icons.flag_outlined,
          title: 'Priority',
          value: selectedPriority,
          onTap: () => _showPriorityDialog(context),
          showChevron: true,
        ),
      ],
    );
  }

  void _showPriorityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Priority'),
          children: priorities
              .map(
                (priority) => SimpleDialogOption(
                  onPressed: () {
                    onPrioritySelected(priority);
                    Navigator.pop(context);
                  },
                  child: Text(priority),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
