import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class MissingItemDialog extends StatelessWidget {
  final String missingItem;
  final VoidCallback onGeneratePressed; // 🚀 بنستقبل الدالة اللي هتتنفذ عشان نفصل اللوجيك عن الـ UI

  const MissingItemDialog({
    super.key,
    required this.missingItem,
    required this.onGeneratePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.blue),
          SizedBox(width: 10),
          Text('Missing Item!'),
        ],
      ),
      content: Text('You don\'t have a $missingItem in your wardrobe.\n\nDo you want me to generate an outfit using what you currently have?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButton,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.pop(context);
            onGeneratePressed(); // 🚀 بننفذ الدالة اللي جاتلنا من الشاشة الأصلية
          },
          child: const Text('Yes, Generate', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}