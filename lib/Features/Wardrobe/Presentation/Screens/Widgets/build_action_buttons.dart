import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/custom_button.dart';

class BuildActionButtons extends StatelessWidget {
  const BuildActionButtons({super.key, required this.context, required this.onEdit, required this.onDelete});
  final BuildContext context;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          title: "EDIT ITEM",
          icon: Icons.edit_rounded,
          color: AppColors.primaryButton,
          onPressed: () => onEdit(),
        ),
        const SizedBox(height: 20),
        CustomButton(
          title: "DELETE ITEM",
          icon: Icons.delete_outline_rounded,
          color: AppColors.errorColor,
          onPressed: () => onDelete(),
        ),
      ],
    );
  }
}
