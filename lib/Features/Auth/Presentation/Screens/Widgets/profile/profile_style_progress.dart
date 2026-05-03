
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class ProfileStyleProgress extends StatelessWidget {
  const ProfileStyleProgress({
    super.key,
    required this.title,
    required this.percentage,
    required this.color,
  });

  final String title;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.titleColor,
              ),
            ),
            Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.subtitleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
