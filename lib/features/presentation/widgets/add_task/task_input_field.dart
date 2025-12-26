import 'package:flutter/material.dart';

class TaskInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLines;

  const TaskInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        isDense: true,
      ),
      maxLines: maxLines,
      validator: validator,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
