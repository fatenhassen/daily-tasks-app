import 'package:daily_tasks_app/core/app_colors.dart';
import 'package:daily_tasks_app/features/domain/models/category_model.dart';
import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  final String selectedCategoryId;
  final List<Category> categories;
  final ValueChanged<String> onCategorySelected;

  const CategorySelection({
    super.key,
    required this.selectedCategoryId,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...widget.categories.map((category) {
                final isSelected = category.id == widget.selectedCategoryId;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category.name),
                    selected: isSelected,
                    onSelected: (_) => widget.onCategorySelected(category.id),
                    backgroundColor: Colors.grey[200],
                    selectedColor: category.color.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? category.color : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? category.color : Colors.grey[300]!,
                      ),
                    ),
                    avatar: Icon(
                      category.icon,
                      color: isSelected ? category.color : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement add new category
                },
                icon: const Icon(
                  Icons.add,
                  size: 16,
                  color: AppColors.primaryTeal,
                ),
                label: const Text(
                  'New',
                  style: TextStyle(color: AppColors.primaryTeal),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
