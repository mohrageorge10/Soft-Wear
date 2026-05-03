
import 'package:flutter/material.dart';
import 'package:soft_wear/Core/AI/clothing_item_model.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';

class BuildUIHero extends StatelessWidget {
  const BuildUIHero({
    super.key,
    required ClothingItem currentItem,
    required this.hashCode,
    required this.context,
  }) : _currentItem = currentItem;

  final ClothingItem _currentItem;
  final int hashCode;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _currentItem.id.isNotEmpty ? _currentItem.id : _currentItem.hashCode.toString(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: AppColors.textFieldFill,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [AppColors.boxShadow()],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: (_currentItem.imageUrl != null && _currentItem.imageUrl!.isNotEmpty)
              ? Image.network(_currentItem.imageUrl!, fit: BoxFit.cover)
              : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
        ),
      ),
    );
  }
}