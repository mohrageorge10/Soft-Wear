
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({
    super.key,
    required ClothingItem currentItem,
  }) : _currentItem = currentItem;

  final ClothingItem _currentItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _currentItem.category.name.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.titleColor, letterSpacing: 1.5),
            ),
            CircleAvatar(backgroundColor: AppColors.getColorFromName(_currentItem.color), radius: 14),
          ],
        ),
        const SizedBox(height: 8),
        Text("Main Color: ${_currentItem.color}", style: const TextStyle(fontSize: 16, color: AppColors.subtitleColor, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
