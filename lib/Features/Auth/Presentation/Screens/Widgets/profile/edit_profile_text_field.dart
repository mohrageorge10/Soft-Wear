
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    required this.isReadOnly,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isReadOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      validator: validator,
      style: TextStyle(
        color: isReadOnly ? Colors.grey : AppColors.titleColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.subtitleColor),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: isReadOnly
            ? Colors.grey.withValues(alpha: 0.1)
            : AppColors.textFieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
