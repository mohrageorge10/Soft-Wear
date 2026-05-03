import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';

class WardrobeWarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onAddPressed; // 🚀 ضفنا المتغير ده

  const WardrobeWarningDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onAddPressed, // 🚀
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.primaryButton.withValues(alpha: 0.7)),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButton,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.pop(context); // 💡 بنقفل الـ Dialog الأول
            onAddPressed(); // 🚀 بننادي على الدالة اللي هتحولنا للتاب الصح
          },
          child: const Text(AppStrings.addItem, style: TextStyle(color: Colors.white)),
        ),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}