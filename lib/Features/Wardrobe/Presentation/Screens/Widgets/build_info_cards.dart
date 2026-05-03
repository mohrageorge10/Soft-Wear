
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Widgets/info_card.dart';

class BuildInfoCards extends StatelessWidget {
  const BuildInfoCards({
    super.key,
    required ClothingItem currentItem,
  }) : _currentItem = currentItem;

  final ClothingItem _currentItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          title: "Suitable Seasons",
          chips: _currentItem.seasons.map((s) => s.name.toUpperCase()).toList(),
          chipColor: AppColors.textFieldFill,
          labelColor: AppColors.primaryColor,
        ),
        InfoCard(
          title: "Style & Occasion",
          chips: _currentItem.styles.map((s) => s.name.toUpperCase()).toList(),
          chipColor: AppColors.primaryColor.withValues(alpha: 0.1),
          labelColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
