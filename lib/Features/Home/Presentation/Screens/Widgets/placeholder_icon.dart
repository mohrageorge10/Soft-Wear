
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class PlaceholderIcon extends StatelessWidget {
  const PlaceholderIcon({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.checkroom_outlined,
          color: AppColors.primaryButton.withValues(alpha: 0.7),
          size: 24,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryButton.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
